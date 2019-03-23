# 2019-02-12 (cc) <paul4hough@gmail.com>
#
class maul::exporter::blackbox(
  Hash $config,
) {

  if $facts['maul_alert_gitlab'] {
    $mod_gitlab = {
      'prometheus::blackbox_exporter' => {
        modules => lookup('maul::blackbox_mod_gitlab'),
      }
    }
  } else {
    $mod_gitlab = {}
  }
  if $facts['maul_alert_cloudera'] {
    $mod_cloudera = {
      'prometheus::blackbox_exporter' => {
        modules => lookup('maul::blackbox_mod_cloudera'),
      }
    }
  } else {
    $mod_cloudera = {}
  }
  if $facts['maul_alert_hpsm'] {
    $mod_hpsm = {
      'prometheus::blackbox_exporter' => {
        modules => lookup('maul::blackbox_mod_hpsm'),
      }
    }
  } else {
    $mod_hpsm = {}
  }
  $blackbox_cfg = deep_merge(
    $config,
    $mod_gitlab,
    $mod_cloudera,
    $mod_hpsm)

  create_resources('class', $blackbox_cfg )

}
