<?php

Route::get("api/salosdeevento","salones_eventos\SalonEventoController@GetAll");
Route::get("api/salosdeevento/{salon_id}","salones_eventos\SalonEventoController@GetAll_ID");
Route::post("api/salosdeevento","salones_eventos\SalonEventoController@Store");
Route::post("api/salosdeevento/update","salones_eventos\SalonEventoController@Update");
Route::delete("api/salosdeevento/{salon_id}","salones_eventos\SalonEventoController@Delete"); 
Route::delete("api/salosdeevento/{salon_id}/definitivamente", "salones_eventos\SalonEventoController@eliminarSalonDefinitivamente");

Route::post("api/salosdeevento/imagenes","salones_eventos\SalonEventoController@StoreImagenes");