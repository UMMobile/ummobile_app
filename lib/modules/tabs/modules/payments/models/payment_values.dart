class PaymentValues {
  String? programId;
  String? amountId;
  String? amountSum;
  bool wantsFacture;
  String? nameRFC;
  String? rFC;
  String? useCFDI;
  String? address;

  PaymentValues(
      {this.programId,
      this.amountId,
      this.amountSum,
      this.wantsFacture = false,
      this.nameRFC,
      this.rFC,
      this.useCFDI,
      this.address});

  factory PaymentValues.clearData() => PaymentValues(
        programId: null,
        amountId: null,
        amountSum: null,
        wantsFacture: false,
        nameRFC: null,
        rFC: null,
        useCFDI: null,
        address: null,
      );
}
