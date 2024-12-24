import 'package:control_asistencia_daemon/lib.dart';
import 'package:flutter/material.dart';

class RoomCard extends StatelessWidget {
  final Room room;

  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    var backgroundColor = Theme.of(context).colorScheme.secondary;
    return LayoutBuilder(builder: (context, BoxConstraints constrains) {
      var isScreenLarge = constrains.maxWidth > 236.0;
      var textStyleNormal = isScreenLarge
          ? Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: backgroundColor,
              )
          : Theme.of(context).textTheme.titleLarge?.copyWith(
                color: backgroundColor,
              );

      var textStyleSmall = isScreenLarge
          ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: backgroundColor,
              )
          : Theme.of(context).textTheme.labelLarge?.copyWith(
                color: backgroundColor,
              );
      var textStyleSmallBold = isScreenLarge
          ? TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: backgroundColor,
            )
          : TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: backgroundColor,
            );
      return DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: backgroundColor,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: backgroundColor,
                ),
                child: ListImageCarousel(
                  images: room.imagenes,
                  maxWidth: constrains.maxWidth,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      room.nombresalon,
                      style: textStyleNormal,
                      textAlign: TextAlign.center,
                    ),
                    if (isScreenLarge) const SizedBox(height: 10),
                    if (isScreenLarge)
                      _buildFeatures(textStyleSmall, textStyleSmallBold),
                    if (isScreenLarge) const SizedBox(height: 10),
                    if (isScreenLarge)
                      _buildPrices(textStyleSmall, textStyleSmallBold)
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Row _buildFeatures(TextStyle? textStyleSmall, TextStyle textStyleSmallBold) {
    return Row(
      children: [
        ...{
          "Capacidad": room.capacidad.toString(),
          "Estado": room.estado,
        }.entries.map(
          (entry) {
            return Expanded(
              child: Column(
                children: [
                  Text(
                    entry.key,
                    style: textStyleSmall,
                    textAlign: TextAlign.center,
                  ),
                  Text(entry.value, style: textStyleSmallBold),
                ],
              ),
            );
          },
        ).expand((element) => [element, const SizedBox(width: 10)]),
      ],
    );
  }

  Row _buildPrices(TextStyle? textStyleSmall, TextStyle textStyleSmallBold) {
    return Row(
      children: [
        ...{
          "Precio por dia": currencyFormat(room.valordia),
          "Precio por medio dia": currencyFormat(room.valormediodia),
        }.entries.map((entry) {
          return Expanded(
            child: Column(
              children: [
                Text(
                  entry.key,
                  style: textStyleSmall,
                  textAlign: TextAlign.center,
                ),
                Text(entry.value, style: textStyleSmallBold),
              ],
            ),
          );
        }).expand((element) => [element, const SizedBox(width: 10)])
      ],
    );
  }
}

class ListImageCarousel extends StatefulWidget {
  const ListImageCarousel({
    super.key,
    required this.images,
    this.maxWidth = 300,
  });

  final List<Imagen> images;
  final double maxWidth;

  @override
  State<ListImageCarousel> createState() => _ListImageCarouselState();
}

class _ListImageCarouselState extends State<ListImageCarousel> {
  final _carouselController = CarouselController();
  bool _isAnimating = false;
  void _nextImage() async {
    if (_isAnimating) return;
    _isAnimating = true;
    final currentOffset = _carouselController.offset;
    final nextOffset = currentOffset + widget.maxWidth;
    if (nextOffset < widget.images.length * widget.maxWidth) {
      await _carouselController.animateTo(nextOffset,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      _isAnimating = false;
    }
  }

  void _previousImage() async {
    if (_isAnimating) return;
    _isAnimating = true;
    final currentOffset = _carouselController.offset;
    final nextOffset = currentOffset - widget.maxWidth;
    if (nextOffset >= 0) {
      await _carouselController.animateTo(nextOffset,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      _isAnimating = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.maxWidth,
      height: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: CarouselView(
              controller: _carouselController,
              itemExtent: double.infinity,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              children: widget.images.isEmpty
                  ? [
                      ColoredBox(
                        color: Theme.of(context).colorScheme.secondary,
                        child: Center(
                          child: Text(
                            'No hay imagenes',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                          ),
                        ),
                      )
                    ]
                  : widget.images
                      .map((e) => CachingImage(
                          url: e.file,
                          fit: BoxFit.cover,
                          borderRadius: 0,
                          errorWidget: ColoredBox(
                            color: Theme.of(context).colorScheme.secondary,
                            child: Center(
                              child: Text(
                                'Error al cargar la imagen',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                    ),
                              ),
                            ),
                          )))
                      .toList(),
            ),
          ),
          if (widget.images.isNotEmpty && widget.images.length > 1)
            Positioned.fill(
              right: .8 * widget.maxWidth,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _previousImage,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(.5),
                          Colors.transparent,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          if (widget.images.isNotEmpty && widget.images.length > 1)
            Positioned.fill(
              left: .8 * widget.maxWidth,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: _nextImage,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(.5),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
