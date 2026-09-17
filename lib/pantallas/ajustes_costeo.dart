import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reposteria_app/l10n/app_localizations.dart';
import '../datos_app.dart';
import '../models/negocio.dart';
import '../tema.dart';
import '../formato.dart';

class _GastoEdit {
  final TextEditingController nombre;
  final TextEditingController valor;
  _GastoEdit(String n, double v)
      : nombre = TextEditingController(text: n),
        valor = TextEditingController(text: v > 0 ? cantidadStr(v) : '');
}

class PantallaAjustesCosteo extends StatefulWidget {
  const PantallaAjustesCosteo({super.key});

  @override
  State<PantallaAjustesCosteo> createState() => _PantallaAjustesCosteoState();
}

class _PantallaAjustesCosteoState extends State<PantallaAjustesCosteo> {
  late final TextEditingController tarifaCtrl;
  late final TextEditingController energiaCtrl;
  late final TextEditingController lotesCtrl;
  late final TextEditingController margenCtrl;
  late final TextEditingController margenEspCtrl;
  late final TextEditingController ivaCtrl;
  final List<_GastoEdit> gastos = [];
  String metodoMargen = 'venta';
  bool ivaAplica = false;

  @override
  void initState() {
    super.initState();
    final n = context.read<DatosApp>().negocio;
    tarifaCtrl = TextEditingController(
        text: (n?.tarifaHora ?? 0) > 0 ? cantidadStr(n!.tarifaHora) : '');
    energiaCtrl = TextEditingController(
        text: (n?.costoEnergiaHora ?? 0) > 0
            ? cantidadStr(n!.costoEnergiaHora)
            : '');
    lotesCtrl = TextEditingController(
        text: (n?.lotesMes ?? 0) > 0 ? cantidadStr(n!.lotesMes) : '');
    margenCtrl = TextEditingController(text: cantidadStr(n?.margenPct ?? 40));
    margenEspCtrl =
        TextEditingController(text: cantidadStr(n?.margenEspecialPct ?? 50));
    ivaCtrl = TextEditingController(text: cantidadStr(n?.ivaTasa ?? 19));
    metodoMargen = n?.metodoMargen ?? 'venta';
    ivaAplica = n?.ivaAplica ?? false;
    for (final g in (n?.gastosFijos ?? const <GastoFijo>[])) {
      gastos.add(_GastoEdit(g.nombre, g.valor));
    }
  }

  @override
  void dispose() {
    for (final c in [tarifaCtrl, energiaCtrl, lotesCtrl, margenCtrl,
      margenEspCtrl, ivaCtrl]) {
      c.dispose();
    }
    for (final g in gastos) {
      g.nombre.dispose();
      g.valor.dispose();
    }
    super.dispose();
  }

  double get _totalGastos =>
      gastos.fold(0.0, (a, g) => a + parseCantidad(g.valor.text));

  void _guardar() async {
    final t = AppLocalizations.of(context)!;
    final lista = <GastoFijo>[];
    for (final g in gastos) {
      final nombre = g.nombre.text.trim();
      final valor = parseCantidad(g.valor.text);
      if (nombre.isNotEmpty || valor > 0) {
        lista.add(GastoFijo(nombre: nombre, valor: valor));
      }
    }
    await context.read<DatosApp>().guardarAjustesCosteo(
          tarifaHora: parseCantidad(tarifaCtrl.text),
          costoEnergiaHora: parseCantidad(energiaCtrl.text),
          gastosFijos: lista,
          lotesMes: parseCantidad(lotesCtrl.text),
          metodoMargen: metodoMargen,
          margenPct: parseCantidad(margenCtrl.text),
          margenEspecialPct: parseCantidad(margenEspCtrl.text),
          ivaAplica: ivaAplica,
          ivaTasa: parseCantidad(ivaCtrl.text),
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(t.costeoGuardado)));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final m = AppColores.of(context);
    final lotes = parseCantidad(lotesCtrl.text);
    final porLote = lotes > 0 ? _totalGastos / lotes : 0.0;

    return Scaffold(
      appBar: AppBar(title: Text(t.ajustesCosteoTitulo)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _seccion(m, t.costeoNegocioTiempo),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: tarifaCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [Decimal2Formatter()],
                    decoration: InputDecoration(
                        labelText: t.costeoTarifaHora,
                        prefixIcon: const Icon(Icons.schedule)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: energiaCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [Decimal2Formatter()],
                    decoration: InputDecoration(
                        labelText: t.costeoEnergiaHoraLabel,
                        prefixIcon: const Icon(Icons.local_fire_department_outlined)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _seccion(m, t.costeoGastosMes),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...gastos.asMap().entries.map((e) {
                    final g = e.value;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextField(
                              controller: g.nombre,
                              decoration:
                                  InputDecoration(labelText: t.costeoConcepto),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: g.valor,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: [Decimal2Formatter()],
                              onChanged: (_) => setState(() {}),
                              decoration: InputDecoration(
                                  labelText: t.costeoValorMensual),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: m.rojo),
                            onPressed: () => setState(() {
                              g.nombre.dispose();
                              g.valor.dispose();
                              gastos.removeAt(e.key);
                            }),
                          ),
                        ],
                      ),
                    );
                  }),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () =>
                          setState(() => gastos.add(_GastoEdit('', 0))),
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(t.costeoAgregarConcepto),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: lotesCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [Decimal2Formatter()],
                    onChanged: (_) => setState(() {}),
                    decoration:
                        InputDecoration(labelText: t.costeoLotesMes),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    t.costeoTotalMensual(
                        pesos(_totalGastos), pesos(porLote)),
                    style: TextStyle(fontSize: 12, color: m.textoSuave),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _seccion(m, t.costeoMargenSeccion),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: metodoMargen,
                    isExpanded: true,
                    decoration:
                        InputDecoration(labelText: t.prodMetodoMargen),
                    items: [
                      DropdownMenuItem(
                          value: 'venta', child: Text(t.prodMetodoVenta)),
                      DropdownMenuItem(
                          value: 'markup', child: Text(t.prodMetodoMarkup)),
                    ],
                    onChanged: (v) => setState(() => metodoMargen = v ?? 'venta'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: margenCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [Decimal2Formatter()],
                          decoration: InputDecoration(
                              labelText: t.costeoMargenGeneral),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: margenEspCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [Decimal2Formatter()],
                          decoration: InputDecoration(
                              labelText: t.costeoMargenEspecial),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _seccion(m, t.costeoIva),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  SwitchListTile(
                    value: ivaAplica,
                    onChanged: (v) => setState(() => ivaAplica = v),
                    title: Text(t.costeoIvaAplica),
                  ),
                  if (ivaAplica)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: TextField(
                        controller: ivaCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [Decimal2Formatter()],
                        decoration:
                            InputDecoration(labelText: t.costeoIvaTasa),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _guardar, child: Text(t.guardar)),
        ],
      ),
    );
  }

  Widget _seccion(MarcaColores m, String titulo) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(titulo,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: m.texto)),
      );
}
