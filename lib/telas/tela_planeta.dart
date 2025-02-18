// ignore_for_file: unused_element

import 'package:flutter/material.dart';

import '../controles/controle_planeta.dart';
import '../modelos/planeta.dart';

class TelaPlaneta extends StatefulWidget {
  final bool isIncluir;
  final Planeta planeta;
  final Function() onFinalizado;

  const TelaPlaneta({
    super.key,
    required this.isIncluir,
    required this.planeta,
    required this.onFinalizado,
  });

  @override
  State<TelaPlaneta> createState() => _TelaPlanetaState();
}

class _TelaPlanetaState extends State<TelaPlaneta> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _tamanhoController = TextEditingController();
  final TextEditingController _distanciaController = TextEditingController();
  final TextEditingController _apelidoController = TextEditingController();

  final ControlePlaneta _controlePlaneta = ControlePlaneta();

  late Planeta _planeta;

  @override
  void initState() {
    _planeta = widget.planeta;
    _nomeController.text = _planeta.nome;
    _tamanhoController.text = _planeta.tamanho.toString();
    _distanciaController.text = _planeta.distancia.toString();
    _apelidoController.text = _planeta.apelido ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _tamanhoController.dispose();
    _distanciaController.dispose();
    _apelidoController.dispose();
    super.dispose();
  }

  Future<void> _salvarPlaneta() async {
    await _controlePlaneta.inserirPlaneta(_planeta);
  }

  Future<void> _alterarPlaneta() async {
    await _controlePlaneta.alterarPlaneta(_planeta);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Dados validados com sucesso
      _formKey.currentState!.save();

      if (widget.isIncluir) {
        _salvarPlaneta();
      } else {
        _alterarPlaneta();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dados do Planeta foram ${widget.isIncluir? 'incluídos' : 'alterados'} com sucesso!'),
      ),);
      Navigator.of(context).pop();
      widget.onFinalizado();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cadastrar Planeta'),
        elevation: 3,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nomeController,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        20.0,
                      ), //Define os cantos arredondados
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return 'Por favor, insira o nome do Planeta(3 ou mais caracteres)';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.nome = value!;
                  },
                ),
                TextFormField(
                  controller: _tamanhoController,
                  decoration: InputDecoration(
                    labelText: 'Tamanho (em Km)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        30.0,
                      ), //Define os cantos arredondados
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o tamanho do Planeta';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, insira um valor numérico válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.tamanho = double.parse(value!);
                  },
                ),
                TextFormField(
                  controller: _distanciaController,
                  decoration: InputDecoration(
                    labelText: 'Distancia do Sol',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        50.0,
                      ), //Define os cantos arredondados
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira a distancia do Planeta';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Por favor, insira um valor numérico válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _planeta.distancia = double.parse(value!);
                  },
                ),
                TextFormField(
                  controller: _apelidoController,
                  decoration: InputDecoration(
                    labelText: 'Apelido do Planeta',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        70.0,
                      ), //Define os cantos arredondados
                    ),
                  ),
                  onSaved: (value) {
                    _planeta.apelido = value;
                  },
                ),
                const SizedBox(
                  height: 20.0
                  ),
                  Row(
                    
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [   
                      ElevatedButton(
                  onPressed:() => Navigator.of(context).pop(),
                  child: const Text('Cancela'),
                ),
                  ElevatedButton(
                  onPressed: _submitForm, // _submitForm,
                  child: const Text('Confirmar'),
                )],)
                ,
              ],
            ),
          ),
        ),
      ),
    );
  }
}