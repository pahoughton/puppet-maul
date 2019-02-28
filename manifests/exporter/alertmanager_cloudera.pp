# 2019-02-28 (cc) <paul4hough@gmail.com>
#
class maul::exporter::alertmanager_cloudera(
  Hash $config
) {
  create_resources('class', $config )
}
