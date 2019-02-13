# 2019-02-12 (cc) <paul4hough@gmail.com>
#
class maul::exporter::consul(
  $config,
) {

  create_resources('class', $config )

}
