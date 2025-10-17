const _k0_9 = '[0-9]'; // 0-9
const _k10_99 = '[1-9][0-9]'; // 10-99
const _k100_199 = '1[0-9][0-9]'; // 100-199
const _k200_249 = '2[0-4][0-9]'; // 200-249
const _k250_255 = '25[0-5]'; // 250-255
const _kDot = r'\.';
const _k0_255Dot =
    '(?:$_k250_255$_kDot|$_k200_249$_kDot|$_k100_199$_kDot|$_k10_99$_kDot|$_k0_9$_kDot)';
const _k0_255 = '(?:$_k250_255|$_k200_249|$_k100_199|$_k10_99|$_k0_9)';

abstract base class ExpUtil {
  static RegExp get ipAddress => RegExp('$_k0_255Dot{3}$_k0_255');
}
