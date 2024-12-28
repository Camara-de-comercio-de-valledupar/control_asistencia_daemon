<?php

namespace App\Http\Controllers\salones_eventos;

use Illuminate\Http\Request;

use App\Http\Requests;
use App\Http\Controllers\Controller;
use App\Entidades\RespuestaDto;
use App\Models_SalonEvento\SalonEvento;
use App\Models_SalonEvento\Imagenes_Salones;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;
use Illuminate\Support\Facades\Storage;


class SalonEventoController extends Controller
{

    public function __construct(){

        $this->middleware('cors');
    }

    public function getAllSalones(){
        
        $salones = SalonEvento::orderBy('nombresalon', 'desc')->get();
        
        foreach($salones as $c) { 
            
            $imagenes = Imagenes_Salones::orderBy('file', 'desc')
                                        ->where('salones_imagenes_id', $c->id)
                                        ->get();                    
                    foreach($imagenes as $i){
                        $i->file = url('img/fotosalones/'.$i->file);
                        $imagenes[] = $i;

                    }
            $c->imagenes = $imagenes;
        }

        if(!empty($salones)){

            return $salones;
        }
    }

    public function GetAll(){

        $respuesta = new RespuestaDto();

        $salones = SalonEvento::orderBy('nombresalon', 'desc')->get();
        
        foreach($salones as $c) { 
            
            $imagenes = Imagenes_Salones::orderBy('file', 'desc')
                                        ->where('salones_imagenes_id', $c->id)
                                        ->get();                    
                    foreach($imagenes as $i){
                        $i->file = url('img/fotosalones/'.$i->file);
                        $imagenes[] = $i;
                    }
            $c->imagenes = $imagenes;
        }

        if(!empty($salones)){

            $respuesta->error   = false;
            $respuesta->mensaje = "Cargando datos";
            $respuesta->datos   = $salones;
        }
        else{
            $respuesta->error = true;
            $respuesta->mensaje = "El Salón que desea consultar no se encuentra registrado";
        }
        return response()->json($respuesta); 
    }

    private function ValidarNombre($nombre){

        $salonExiste = false;

        $salones = SalonEvento::where('nombresalon', $nombre)->first();
        if(!empty($salones)){

            $salonExiste = true;
        }
        else{
            $salonExiste = false;
        }
        return $salonExiste; 
    }

    private function ValidarNombreID($nombre, $id){

        $respuesta = new RespuestaDto();

        $salones = SalonEvento::where('nombresalon', $nombre)
                                ->where('estado', 'Habilitado')
                                ->first();
        if(empty($salones)){

            $respuesta->error = true;
        }
        else{
            $respuesta->error = false;
            $respuesta->datos = $salones;
        }
        return response()->json($respuesta); 
    }

    public function Store(Request $request){
        try {
            $datos = $request->all();
            $respuesta = new RespuestaDto();

            if (!empty($datos["nombresalon"]) && !empty($datos["valormediodia"]) && !empty($datos["valordia"]) && !empty($datos["capacidad"]) && !empty($datos["ubicacion"]))  {

                if(!$this->ValidarNombre($datos["nombresalon"])){

                    $salon = new SalonEvento();

                    $salon->nombresalon     = $datos["nombresalon"];
                    $salon->ubicacion       = $datos["ubicacion"];
                    $salon->descripcion     = $datos["descripcion"];
                    $salon->valormediodia   = $datos["valormediodia"];
                    $salon->valordia        = $datos["valordia"];
                    $salon->capacidad       = $datos["capacidad"];
                    $salon->estado          = "Habilitado";

                    $img = $request->get('imagen');
                    if( $img ){
                        $image_path = $img->getClientOriginalName();
                        \Storage::disk('salonesportada')->put($image_path, \File::get($img));
                        $salon->imagen           = $image_path;
                    }

                    if ($salon->save()) {

                        $respuesta->error = false;
                        $respuesta->mensaje = "Salón registrador exitosamente";
                        
                    } else {

                        $respuesta->error = true;
                        $respuesta->mensaje = "No se pudo registrar el Salón, intente nuevamente.";
                    }
                }
                else{
                    $respuesta->error = true;
                    $respuesta->mensaje = "El Salón que desea registrar ya existe.";
                }
            } else {
                $respuesta->error = true;
                $respuesta->mensaje = "Verifique que todos los campos esten llenos";
            }
        } catch (Exception $exc) {
            $respuesta->error = true;
            $respuesta->mensaje = $exc->getTraceAsString();
        }
        return response()->json($respuesta);
    }

    public function Update(Request $request){
        try{
            $datos = $request->all();
            $respuesta = new RespuestaDto();

            if(!empty($datos["id"]) && !empty($datos["nombresalon"]) && !empty($datos["valormediodia"]) && !empty($datos["valordia"]) && !empty($datos["capacidad"]) ){
                
                $salon = SalonEvento::find($datos["id"]);                    
                if(!empty($salon)){

                    $salon->nombresalon     = $datos["nombresalon"];
                    $salon->ubicacion       = $datos["ubicacion"];
                    $salon->descripcion     = $datos["descripcion"];
                    $salon->valormediodia   = $datos["valormediodia"];
                    $salon->valordia        = $datos["valordia"];
                    $salon->capacidad       = $datos["capacidad"];
                    $salon->estado          = $datos["estado"];

                    $img = $salon->imagen;
                    if( $salon->imagen != $datos["imagen"] ){
                        $image_path = $datos["imagen"]->getClientOriginalName();
                        \Storage::disk('salonesportada')->put($image_path, \File::get($datos["imagen"]));
                        $salon->imagen           = $image_path;
                    }

                    if ($salon->save()) {

                        $respuesta->error = false;
                        $respuesta->mensaje = "Salón actualizado exitosamente";
                        $this->EliminarImagen($img);
                    } else {

                        $respuesta->error = true;
                        $respuesta->mensaje = "No se pudo actualizar el Salón, intente nuevamente.";
                    }
                }
                else{
                    $respuesta->error = true;
                    $respuesta->mensaje = "El Salón que desea modificar no se encuentra registrado, intente nuevamente.";
                }
            }
            else{
                $respuesta->error = true;
                $respuesta->mensaje = "Verifique que todos los campos esten llenos";
            }
        }catch (Exception $exc){
            $respuesta->error = true;
            $respuesta->mensaje = $exc->getMessage();
        }
        return response()->json($this->getAllSalones()); 
    }

    private function EliminarImagen($imagen){
        
        if(Storage::disk('fotosalones')->exists($imagen)){

            Storage::disk('fotosalones')->delete($imagen);
        }
    }

    public function GetAll_ID($salon_id){

        $respuesta = new RespuestaDto();

        $salon = SalonEvento::find($salon_id);
        
        if ($salon){
        $imagenes = Imagenes_Salones::orderBy('file', 'desc')
                    ->where('salones_imagenes_id', $salon_id)
                    ->get();

        $salon->imagenes = $imagenes;

        

            $respuesta->error = false;
            $respuesta->mensaje = "Cargando datos";
            $respuesta->datos = $salon;
        }
        else{
            $respuesta->error = true;
            $respuesta->mensaje = "El Salón que desea consultar no se encuentra registrado";
        }
        return response()->json($respuesta); 
    }

    public function Delete($salon_id){

        $respuesta = new RespuestaDto();

        if(!empty($salon_id)){

            $salon = SalonEvento::find($salon_id);

            if($salon){

                $salon->estado  = "Inhabilitado";

                if($salon->save()){

                    $respuesta->error = false;
                    $respuesta->mensaje = "Salón Inhabilitado exitosamente";
                }
                else{
                    $respuesta->error = true;
                    $respuesta->mensaje = "No se pudo Inhabilitar el Salón, intente nuevamente";
                }
            }
            else{
                $respuesta->error = true;
                $respuesta->mensaje = "El Salón que desea eliminar no se encuentra registrado";
            }
        }
        else{
            $respuesta->error = true;
            $respuesta->mensaje = "Verifique que haya seleccionado un Salón para eliminar";
        }
        return response()->json($respuesta); 
    }

    public function StoreImagenes(Request $request){

        try {
            
            $respuesta = new RespuestaDto();
            $salonId = $request->salones_imagenes_id;
            $file1 = $request->file1;
            $file2 = $request->file2;
            $file3 = $request->file3;
            $file4 = $request->file4;
            $file5 = $request->file5;
            $file6 = $request->file6;
            $files = [$file1, $file2, $file3, $file4, $file5, $file6];
            
            // Si todas la imagenes son null
            if(empty(array_filter($files, function($value){
                return !is_null($value);
            }))){
                $respuesta->error = true;
                $respuesta->mensaje = "No hay imagenes asociadas";
                return response()->json($respuesta);
            }
            
            // Buscar las imagenes del salon y borrarlas
            $imagenes = Imagenes_Salones::where('salones_imagenes_id', $salonId)->get();
            foreach($imagenes as $img) { 
                Imagenes_Salones::destroy($img->id);
                Storage::disk('fotosalones')->delete($img->file);
            }
            // Guardar las nuevas imagenes del salon
            foreach($files as $file){
                if(!empty($file)){
                    $this->GuardarImagenes($salonId, $file);
                }
            }

            
            $respuesta->error = false;
            $respuesta->mensaje = "Imagenes almacenadas exitosamente.";
            //$respuesta->datos = $salon;

        } catch (Exception $exc) {
            $respuesta->error = true;
            $respuesta->mensaje = $exc->getTraceAsString();
        }
        return response()->json($respuesta); 
    }

    public function GuardarImagenes($salones_imagenes_id, $file){
        
        $imagen_salon = new Imagenes_Salones();
        $image_path = Carbon::now()->hour.Carbon::now()->minute.Carbon::now()->second.$file->getClientOriginalName();
        $imagen_salon->salones_imagenes_id = $salones_imagenes_id;
        $imagen_salon->file = $image_path;
        \Storage::disk('fotosalones')->put($image_path, \File::get($file));
        $imagen_salon->save();
    }


    public function eliminarSalonDefinitivamente($salonId){
        $respuesta = new RespuestaDto();

        if (!empty($salonId)) {
            $salon = SalonEvento::find($salonId);
            if ($salon) {
                $imagenes = Imagenes_Salones::where('salones_imagenes_id', $salonId)->get();
                foreach ($imagenes as $img) {
                    Imagenes_Salones::destroy($img->id);
                    Storage::disk('fotosalones')->delete($img->file);
                }
                SalonEvento::destroy($salonId);
                $respuesta->error = false;
                $respuesta->mensaje = "Salón eliminado exitosamente";
                
            } else {
                $respuesta->error = true;
                $respuesta->mensaje = "El Salón que desea eliminar no se encuentra registrado";
            }
        } else {
            $respuesta->error = true;
            $respuesta->mensaje = "Verifique que haya seleccionado un Salón para eliminar";
        }

        return response()->json($respuesta);
    }
}
