import 'package:json_path/src/selector/joint.dart';
import 'package:json_path/src/selector/selector.dart';

abstract class SelectorBase implements Selector {
  const SelectorBase();

  /// Combines this expression with the [other]
  @override
  Selector followedBy(Selector other) => Joint(this, other);
}
