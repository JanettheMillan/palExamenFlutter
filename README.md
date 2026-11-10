# Pre-examen Unidad II — Cafetería UTEZ (Flutter · MVVM · provider)

Repo de estudio para el examen práctico de la Unidad II. Aquí está la app (`cafe_utez/`) y esta guía, que te lleva **paso a paso** desde una carpeta vacía hasta el `.zip` de entrega.

- La app está hecha con lo mismo que vimos en clase: **capas dominio / datos / presentación, MVVM con `ChangeNotifier`, repositorio con contrato y `provider`**.
- Cumple lo que pide el kit del profe: **90 / 90** en `autoevaluar.sh` y "todo OK" en `verificar_practica.sh`.

```
PRE-EXAMEN-UNIDAD-II/        (en GitHub: palExamenFlutter)
├── README.md                ← esta guía
├── kit/                     ← kit del profe (solo en local, está en .gitignore)
└── cafe_utez/               ← la app
    ├── pubspec.yaml         name: cafe_utez + provider
    ├── lib/
    │   ├── dominio/pedido.dart                     (paso 2)
    │   ├── datos/pedido_repository.dart            (paso 3)
    │   ├── datos/memoria_pedido_repository.dart    (paso 3)
    │   ├── presentacion/pedidos_view_model.dart    (paso 4)
    │   ├── main.dart                               (paso 5)
    │   ├── presentacion/pedidos_page.dart          (paso 6)
    │   └── presentacion/nuevo_pedido_page.dart     (paso 7)
    └── test/pedidos_view_model_test.dart           (paso 8) ← la ÚNICA prueba propia
```

**Para correrla ya mismo:**

```bash
cd cafe_utez
flutter pub get
flutter run -d chrome        # o: flutter run -d macos
```

---

## Índice

1. [Lo que viste en clase y dónde aparece aquí](#1-lo-que-viste-en-clase-y-dónde-aparece-aquí)
2. [Qué pide el profe (el kit)](#2-qué-pide-el-profe-el-kit)
3. [Mapa de la app](#3-mapa-de-la-app)
4. [Paso a paso](#4-paso-a-paso)
   - [Paso 0 · Preparar provider para trabajar sin internet](#paso-0--preparar-provider-para-trabajar-sin-internet)
   - [Paso 1 · Crear el proyecto](#paso-1--crear-el-proyecto)
   - [Paso 2 · Dominio](#paso-2--dominio)
   - [Paso 3 · Datos](#paso-3--datos)
   - [Paso 4 · ViewModel](#paso-4--viewmodel)
   - [Paso 5 · main.dart](#paso-5--maindart)
   - [Paso 6 · Pantalla de lista](#paso-6--pantalla-de-lista-pedidospage)
   - [Paso 7 · Pantalla de formulario](#paso-7--pantalla-de-formulario-nuevopedidopage)
   - [Paso 8 · Tu prueba](#paso-8--tu-prueba)
   - [Paso 9 · Verificar con el kit](#paso-9--verificar-con-el-kit)
   - [Paso 10 · Entregar](#paso-10--entregar)
5. [Los 4 tipos de estado](#5-los-4-tipos-de-estado)
6. [Hoja de contratos](#6-hoja-de-contratos)
7. [Errores frecuentes](#7-errores-frecuentes)
8. [Experimentos para entenderlo de verdad](#8-experimentos-para-entenderlo-de-verdad)
9. [Preguntas de repaso](#9-preguntas-de-repaso)
10. [Plan de estudio y simulacro de 90 min](#10-plan-de-estudio-y-simulacro-de-90-min)
11. [Checklist antes de entregar](#checklist-antes-de-entregar)

---

## 1. Lo que viste en clase y dónde aparece aquí

La Cafetería es **la misma receta que EcoTrack Meta** (U1-S03-A02, variante B · provider), con otros nombres y una pantalla extra que se abre con `Navigator.push`.

| En clase (EcoTrack Meta) | En el examen (Cafetería UTEZ) | Qué es |
|---|---|---|
| `laboratoriosUtez` | `productosCafe` | Constante del dominio (no es estado) |
| `Consumo` | `Pedido` | Entidad `const` con campos `final` |
| `validarLitros(double?)` | `validarCliente(String)` y `validarCantidad(int?)` | Reglas: regresan el mensaje de error o `null` |
| `ConsumoRepository` | `PedidoRepository` | Contrato `abstract class` |
| `MemoriaConsumoRepository` | `MemoriaPedidoRepository` | Implementación con lista privada + `List.unmodifiable` |
| `ConsumosViewModel` | `PedidosViewModel` | `extends ChangeNotifier`, recibe el contrato |
| `guardar(lab, litrosTexto)` | `registrar(cliente, producto, cantidadTexto)` | Valida → guarda → relee `todos()` → avisa |
| `get total` | `get totalPiezas` | Estado derivado (getter) |
| `AppProvider` en `b_provider.dart` | `CafeUtezApp` en `main.dart` | `ChangeNotifierProvider` **arriba** de `MaterialApp` |
| `FormularioRegistro` | `NuevoPedidoPage` | Stateful por estado efímero, `dispose()`, Dropdown con `setState` |
| `ListaHistorial` | `PedidosPage` | Lista + total |
| `RegistroProvider`, `HistorialProvider` | Las dos páginas | `context.watch` para mostrar, `context.read` para actuar |

**Patrones (actividad de Patrones de diseño) que usa la app:**

| Caso en clase | Patrón | Dónde está aquí |
|---|---|---|
| Caso D · "Ocultar de dónde salen los datos" | **Repository** | `PedidoRepository` + `MemoriaPedidoRepository` |
| Caso B · "Entregar desde fuera el objeto del que se depende" | **Inyección de dependencias** | `PedidosViewModel(repositorio)` y `CafeUtezApp(repositorio: ...)` |
| Caso E · "Avisar a varios interesados sin nombrarlos" | **Observer** | `ChangeNotifier` + `notifyListeners()`; las vistas escuchan con `watch` |

**Lo que vimos en clase pero aquí NO se usa (y por qué):**

- **Variante A (ChangeNotifier puro, `ListenableBuilder`, `vm` por constructor):** el script del profe la marca como FALTA ("recibe o escucha el ViewModel a mano"). En el examen se pide provider.
- **riverpod:** el kit revisa `provider` en `pubspec.yaml` y `context.watch<PedidosViewModel>`.
- **Vistas tontas + adaptadores separados (`vistas.dart`):** aquí cada página usa `watch`/`read` directamente; el script lo busca dentro de `pedidos_page.dart` y `nuevo_pedido_page.dart`.
- **Lo nuevo respecto a EcoTrack:** dos pantallas con `Navigator.push` / `Navigator.pop` (en EcoTrack eran pestañas con `IndexedStack`), borrar un elemento (`entregar`) y `limpiarError()`.

---

## 2. Qué pide el profe (el kit)

El repo del profe (rama `profesor` de este repo) **solo trae el kit**: no trae código, trae las pruebas y scripts con los que se califica. Lo que pide se deduce de ahí:

| Archivo del kit | Qué hace |
|---|---|
| `kit/verificar_practica.sh` | Revisa capas y cableado leyendo tu código (imports, `extends ChangeNotifier`, `watch`/`read`, `push`/`pop`, una sola prueba...). |
| `kit/autoevaluacion_test.dart` | Batería de pruebas: arranca tu app con un **repositorio espía** y revisa textos, `Key`s y comportamiento. |
| `kit/autoevaluar.sh` | Copia tu proyecto a una carpeta temporal, corre todo lo anterior + tu prueba + `flutter analyze` y suma puntos. |

**Rúbrica:**

| Renglón | Puntos | Qué revisa |
|---|---|---|
| R1 Dominio | 15 | `productosCafe`, `cantidadMaxima`, mensajes exactos de `validarCliente` y `validarCantidad` |
| R2 Datos | 10 | `guardar`, `todos`, `entregar`; `todos()` no deja modificar la lista |
| R3 ViewModel | 25 | `ChangeNotifier`, `cargar`, `registrar` (válido / inválido / guardando), `totalPiezas`, `limpiarError` |
| R4 Vistas | 25 | Textos, `Key`s, navegación push/pop, Dropdown, entregar, error que no reaparece |
| R5 Tu prueba | 10 | `test/pedidos_view_model_test.dart` pasa |
| Script de capas | 5 | `verificar_practica.sh` en "todo OK" |
| R6 Docente | 10 | Revisión manual: calidad de tu prueba, app que corre, código limpio |

> Los **textos y `Key`s tienen que ser idénticos** (con acentos y el `·`). Las pruebas buscan `find.text('Pedidos: 0 · Piezas: 0')`; si escribes `Pedidos: 0 - Piezas: 0`, pierdes puntos aunque la app "funcione".

---

## 3. Mapa de la app

```
 PRESENTACIÓN                                     DOMINIO           DATOS
 PedidosPage ─┐  watch (mostrar)                  Pedido            PedidoRepository (abstracto)
 NuevoPedido ─┤  read  (actuar)                   validarCliente           ▲ implements
              ▼                                   validarCantidad   MemoriaPedidoRepository
 PedidosViewModel (ChangeNotifier) ──usa reglas──►       ──usa SOLO el contrato──►
 main.dart: crea MemoriaPedidoRepository y cuelga el ViewModel con ChangeNotifierProvider
```

Regla de oro de las capas (la revisa el script):

- `dominio/` y `datos/` **no importan Flutter** (Dart puro).
- El ViewModel importa `foundation.dart`, **no** `material.dart` ni `provider`.
- Las vistas **no importan nada de `datos/`**.
- `MemoriaPedidoRepository` **solo se importa en `main.dart`**.

Se construye **de abajo hacia arriba**: dominio → datos → ViewModel → main → vistas → prueba.

---

## 4. Paso a paso

Cada paso tiene: **qué haces**, **el código**, **por qué así**, **dónde lo viste en clase** y **cómo comprobarlo**.

### Paso 0 · Preparar provider para trabajar sin internet

**Qué haces:** dejas `provider` (y su dependencia `nested`) en la caché de Dart. Se hace **una sola vez, con internet**, antes del examen.

```bash
dart pub cache add provider --version 6.1.5+1
dart pub cache add nested --version 1.0.0
```

**Por qué:** en el examen no hay internet y `flutter pub add provider --offline` solo funciona si el paquete ya está en caché.

---

### Paso 1 · Crear el proyecto

**Qué haces:** creas el proyecto vacío, agregas provider y las carpetas de las capas.

```bash
flutter create --empty --offline --org mx.edu.utez cafe_utez
cd cafe_utez
flutter pub add provider --offline
mkdir -p lib/dominio lib/datos lib/presentacion test
```

**Por qué así:**

- El nombre **tiene** que ser `cafe_utez`: las pruebas del profe importan `package:cafe_utez/...`. Con otro nombre nada compila.
- `--empty` deja un `main.dart` mínimo y **no crea `test/widget_test.dart`** (el script exige exactamente UNA prueba tuya).
- `--offline` y `pub add --offline` usan la caché del paso 0.

**Comprueba:** en `pubspec.yaml` deben aparecer `name: cafe_utez` y, dentro de `dependencies:`, la línea `provider: ^6.1.5+1`.

> Si algún día falta una plataforma ("This application is not configured to build on the web"), regénérala sin pisar `lib/`:
> `flutter create --org mx.edu.utez --project-name cafe_utez --platforms=web,macos .` y luego `rm -f test/widget_test.dart README.md`.

---

### Paso 2 · Dominio

**Qué haces:** escribes la entidad `Pedido`, las constantes y las dos reglas de validación. Es **Dart puro**: nada de Flutter.

**Archivo:** `cafe_utez/lib/dominio/pedido.dart`

```dart
// DOMINIO — entidad Pedido y sus reglas. Dart puro: no importa Flutter.

// Productos que vende la cafetería. Es una constante, no es estado.
const productosCafe = ['Café', 'Torta', 'Jugo', 'Galletas'];

// Tope de piezas por pedido.
const cantidadMaxima = 5;

// Entidad: un pedido de la cafetería.
class Pedido {
  const Pedido({
    required this.cliente,
    required this.producto,
    required this.cantidad,
  });

  // Nombre de quien pidió.
  final String cliente;
  // Producto pedido; uno de productosCafe.
  final String producto;
  // Piezas, de 1 a cantidadMaxima.
  final int cantidad;
}

// Regla: devuelve el mensaje de error o null si el nombre es válido.
String? validarCliente(String cliente) {
  final limpio = cliente.trim();
  if (limpio.isEmpty) return 'Escribe el nombre del cliente';
  if (limpio.length < 3) return 'El nombre debe tener al menos 3 letras';
  return null;
}

// Regla: devuelve el mensaje de error o null si la cantidad es válida.
// Recibe int? porque el texto puede no ser un número (llega null).
String? validarCantidad(int? cantidad) {
  if (cantidad == null) return 'Escribe la cantidad con número';
  if (cantidad < 1 || cantidad > cantidadMaxima) {
    return 'La cantidad debe ser de 1 a $cantidadMaxima';
  }
  return null;
}
```

**Por qué así:**

- `productosCafe` y `cantidadMaxima` son `const`: **no son estado**, nunca cambian.
- `Pedido` tiene constructor `const` y campos `final`: una vez creado no se modifica.
- Las reglas regresan **el mensaje o `null`**. Así la vista solo muestra el texto, no decide nada.
- `trim()` antes de medir: `' Al '` son 2 letras, no 4.
- `validarCantidad` recibe `int?` (no `String`): convertir texto → número es trabajo del ViewModel.
- El orden de los `if` importa: primero "vacío", luego "muy corto".

**En clase:** `lib/dominio/consumo.dart` de EcoTrack Meta (`laboratoriosUtez`, `Consumo`, `validarLitros`).

**Comprueba:** `flutter analyze lib` → `No issues found!`

---

### Paso 3 · Datos

**Qué haces:** el **contrato** (qué se puede hacer con los pedidos) y una **implementación en memoria**.

**Archivo:** `cafe_utez/lib/datos/pedido_repository.dart`

```dart
// DATOS — contrato del repositorio.
// El ViewModel solo conoce este archivo, nunca la implementación concreta.

import '../dominio/pedido.dart';

abstract class PedidoRepository {
  // Guarda un pedido nuevo al final de la lista.
  Future<void> guardar(Pedido pedido);

  // Quita el pedido que está en esa posición (ya se entregó).
  Future<void> entregar(int indice);

  // Devuelve los pedidos pendientes, en el orden en que se guardaron.
  Future<List<Pedido>> todos();
}
```

**Archivo:** `cafe_utez/lib/datos/memoria_pedido_repository.dart`

```dart
// DATOS — implementación en memoria del contrato.
// Solo main.dart importa esta clase: es el único que elige la fuente de datos.

import '../dominio/pedido.dart';
import 'pedido_repository.dart';

class MemoriaPedidoRepository implements PedidoRepository {
  // Fuente de verdad: los datos viven aquí y se pierden al cerrar la app.
  final List<Pedido> _pedidos = [];

  @override
  Future<void> guardar(Pedido pedido) async => _pedidos.add(pedido);

  @override
  Future<void> entregar(int indice) async => _pedidos.removeAt(indice);

  // Copia no modificable: nadie puede alterar la lista por fuera.
  @override
  Future<List<Pedido>> todos() async => List.unmodifiable(_pedidos);
}
```

**Por qué así:**

- `abstract class` = contrato. El ViewModel depende de él, no de la lista. Mañana puede haber `ApiPedidoRepository` y solo cambia `main.dart`.
- Todo regresa `Future` aunque sea memoria: una API o un disco tardarían, y así no hay que cambiar el contrato después.
- `_pedidos` es **privada** (`_`) y es la **fuente de verdad**.
- `List.unmodifiable` → si alguien hace `lista.add(...)` sobre lo que regresó `todos()`, truena (`UnsupportedError`). R2 lo prueba.

**En clase:** `consumo_repository.dart` y `memoria_consumo_repository.dart` de EcoTrack Meta; y el **Caso D (Repository)** de Patrones.

**Comprueba:** el script del profe revisa que `lib/datos` no importe `package:flutter`, que `PedidoRepository` sea `abstract class` y que `MemoriaPedidoRepository` haga `implements PedidoRepository`.

---

### Paso 4 · ViewModel

**Qué haces:** el **dueño del estado compartido**. Es la pieza más importante (R3 = 25 pts).

**Archivo:** `cafe_utez/lib/presentacion/pedidos_view_model.dart`

```dart
// PRESENTACIÓN — ViewModel con ChangeNotifier.
// No importa material.dart (no dibuja) ni provider (no sabe quién lo entrega).

import 'package:flutter/foundation.dart';

import '../datos/pedido_repository.dart';
import '../dominio/pedido.dart';

class PedidosViewModel extends ChangeNotifier {
  // El repositorio llega desde fuera (inyección de dependencias).
  PedidosViewModel(this._repositorio);

  final PedidoRepository _repositorio;

  // Estado compartido por las dos pantallas.
  List<Pedido> pedidos = [];
  String? error;
  bool guardando = false;

  // Estado derivado: se calcula, no se guarda en un campo.
  int get totalPiezas => pedidos.fold(0, (suma, p) => suma + p.cantidad);

  // Trae lo que ya tenga el repositorio (al arrancar la app).
  Future<void> cargar() async {
    pedidos = await _repositorio.todos();
    notifyListeners();
  }

  // Acción del botón "Agregar". Devuelve true si se guardó.
  Future<bool> registrar(
    String cliente,
    String producto,
    String cantidadTexto,
  ) async {
    final cantidad = int.tryParse(cantidadTexto.trim());
    // Las reglas viven en el dominio; aquí solo se aplican en orden.
    final motivo = validarCliente(cliente) ?? validarCantidad(cantidad);
    if (motivo != null) {
      error = motivo;
      notifyListeners();
      return false;
    }

    guardando = true;
    error = null;
    notifyListeners();

    await _repositorio.guardar(
      Pedido(cliente: cliente.trim(), producto: producto, cantidad: cantidad!),
    );
    // Se vuelve a leer de la fuente de verdad.
    pedidos = await _repositorio.todos();

    guardando = false;
    notifyListeners();
    return true;
  }

  // Se llama antes de abrir el formulario para que no aparezca un error viejo.
  void limpiarError() {
    error = null;
    notifyListeners();
  }

  // Acción del botón "entregar" de cada fila.
  Future<void> entregar(int indice) async {
    await _repositorio.entregar(indice);
    pedidos = await _repositorio.todos();
    notifyListeners();
  }
}
```

**Por qué así:**

- `extends ChangeNotifier` → puede **avisar** (`notifyListeners()`) a quien escuche. Es el patrón **Observer**.
- Importa `foundation.dart`: ahí vive `ChangeNotifier`. No importa `material.dart` porque **no dibuja**, ni `provider` porque **no le importa quién lo entrega**.
- Recibe `PedidoRepository` (el contrato) por constructor → en pruebas le pasas un repo falso (el espía del profe).
- `totalPiezas` es **getter**: se calcula de `pedidos` cada vez; un campo podría quedar desfasado.

**`registrar`, línea por línea:**

1. `int.tryParse(cantidadTexto.trim())` → número, o `null` si escribieron `"dos"`.
2. `validarCliente(...) ?? validarCantidad(...)` → si el cliente falla gana su mensaje; si no, se revisa la cantidad.
3. **Si falla:** `error = motivo` → `notifyListeners()` → `return false`. **No toca el repositorio.**
4. **Si pasa:** `guardando = true; error = null; notifyListeners()` → el botón se desactiva.
5. `await _repositorio.guardar(...)` con `cliente.trim()` (el profe manda `'  Ana  '` y espera `'Ana'`).
6. `pedidos = await _repositorio.todos()` → **se relee la fuente de verdad**, no se hace `pedidos.add(...)`.
7. `guardando = false; notifyListeners(); return true` → sin este último aviso, el botón se queda gris y la lista no se entera.

**En clase:** `ConsumosViewModel` de EcoTrack Meta (`guardar` es casi idéntico a `registrar`).

**Comprueba:** `flutter analyze lib`. El script revisa que no importe `material.dart` ni `provider`, que use `validarCliente` y `validarCantidad`, y que `totalPiezas` sea `get`.

---

### Paso 5 · main.dart

**Qué haces:** armas la app: eliges la fuente de datos y cuelgas el ViewModel en el árbol.

**Archivo:** `cafe_utez/lib/main.dart`

```dart
// Práctica guiada pre-examen Unidad II — Cafetería UTEZ (solución).
// Único archivo que conoce la implementación concreta del repositorio.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'datos/memoria_pedido_repository.dart';
import 'datos/pedido_repository.dart';
import 'presentacion/pedidos_page.dart';
import 'presentacion/pedidos_view_model.dart';

void main() {
  runApp(CafeUtezApp(repositorio: MemoriaPedidoRepository()));
}

class CafeUtezApp extends StatelessWidget {
  const CafeUtezApp({super.key, required this.repositorio});

  final PedidoRepository repositorio;

  @override
  Widget build(BuildContext context) {
    // El provider va ARRIBA de MaterialApp: así la ruta que se abre con
    // Navigator.push también encuentra el ViewModel.
    // create corre una sola vez; el provider libera el ViewModel al salir.
    return ChangeNotifierProvider<PedidosViewModel>(
      // La cascada (..) llama a cargar() y entrega el ViewModel, no el Future.
      create: (_) => PedidosViewModel(repositorio)..cargar(),
      child: MaterialApp(
        title: 'Cafetería UTEZ',
        theme: ThemeData(colorSchemeSeed: Colors.brown),
        home: const PedidosPage(),
      ),
    );
  }
}
```

**Por qué así:**

- `main.dart` es **el único** que conoce `MemoriaPedidoRepository` (lo revisa el script).
- `CafeUtezApp` recibe `repositorio` por constructor: las pruebas del profe hacen `CafeUtezApp(repositorio: RepositorioEspia())`. Si lo creas adentro, el profe no puede meter su espía.
- `ChangeNotifierProvider` va **arriba de `MaterialApp`**. Las pantallas abiertas con `push` cuelgan del `Navigator` (dentro de `MaterialApp`), no de `home`. Si lo pones en `home` → `ProviderNotFoundException` al abrir el formulario.
- `..cargar()` (cascada): ejecuta `cargar()` pero `create` regresa el **ViewModel**, no el `Future`.
- No escribes `dispose()` del ViewModel: el provider lo libera solo.

**En clase:** `AppProvider` en `b_provider.dart` + `main.dart` de EcoTrack Meta.

**Comprueba:** todavía no compila porque falta `PedidosPage` (paso 6) y ésta abre `NuevoPedidoPage` (paso 7). Es normal; compila al terminar el paso 7.

---

### Paso 6 · Pantalla de lista (`PedidosPage`)

**Qué haces:** la pantalla principal: encabezado con totales, lista de pedidos y botón para abrir el formulario.

**Archivo:** `cafe_utez/lib/presentacion/pedidos_page.dart`

```dart
// PRESENTACIÓN — Vista 1: lista de pedidos pendientes.
// Muestra con context.watch y actúa con context.read. No conoce datos/.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'nuevo_pedido_page.dart';
import 'pedidos_view_model.dart';

class PedidosPage extends StatelessWidget {
  const PedidosPage({super.key});

  @override
  Widget build(BuildContext context) {
    // watch: se suscribe; la lista se redibuja con cada notifyListeners().
    final vm = context.watch<PedidosViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cafetería UTEZ')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Pedidos: ${vm.pedidos.length} · Piezas: ${vm.totalPiezas}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Expanded(
            child: vm.pedidos.isEmpty
                ? const Center(child: Text('Sin pedidos'))
                : ListView.builder(
                    itemCount: vm.pedidos.length,
                    itemBuilder: (context, i) {
                      final p = vm.pedidos[i];
                      return ListTile(
                        leading: CircleAvatar(child: Text('${i + 1}')),
                        title: Text(p.producto),
                        subtitle: Text('${p.cliente} · x${p.cantidad}'),
                        trailing: IconButton(
                          key: Key('entregar_$i'),
                          tooltip: 'Entregar',
                          icon: const Icon(Icons.check_circle_outline),
                          // read: dentro de un callback nunca se usa watch.
                          onPressed: () =>
                              context.read<PedidosViewModel>().entregar(i),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('nuevo'),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo pedido'),
        onPressed: () {
          context.read<PedidosViewModel>().limpiarError();
          // push apila el formulario; esta vista queda debajo, intacta.
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NuevoPedidoPage()),
          );
        },
      ),
    );
  }
}
```

**Por qué así:**

- `StatelessWidget`: esta pantalla no tiene estado propio; todo viene del ViewModel.
- **`watch` en `build`** (para mostrar y redibujar). **`read` en `onPressed`** (para actuar; no se suscribe). `watch` en un callback truena.
- `Expanded` alrededor del `ListView`: un `ListView` dentro de `Column` sin `Expanded` da *unbounded height*.
- Textos exactos del contrato: `'Cafetería UTEZ'`, `'Pedidos: N · Piezas: P'`, `'Sin pedidos'`, subtítulo `'Ana · x3'`.
- `Key('entregar_$i')` por fila y `Key('nuevo')` en el FAB: así las encuentran las pruebas.
- El FAB llama **`limpiarError()` antes del `push`**: si no, al reabrir el formulario aparece el error de la vez pasada. No se hace en `initState` del formulario porque eso da *setState() called during build*.

**En clase:** `ListaHistorial` + `HistorialProvider` de EcoTrack Meta (ahí la lista y el `watch` estaban en dos clases; aquí van juntos porque así lo revisa el script).

---

### Paso 7 · Pantalla de formulario (`NuevoPedidoPage`)

**Qué haces:** el formulario: cliente, producto (Dropdown), cantidad, mensaje de error y botón Agregar.

**Archivo:** `cafe_utez/lib/presentacion/nuevo_pedido_page.dart`

```dart
// PRESENTACIÓN — Vista 2: formulario para agregar un pedido.
// Es StatefulWidget solo por el estado efímero (controladores y producto elegido).
// No recibe el ViewModel por constructor: lo pide al árbol con provider.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../dominio/pedido.dart';
import 'pedidos_view_model.dart';

class NuevoPedidoPage extends StatefulWidget {
  const NuevoPedidoPage({super.key});

  @override
  State<NuevoPedidoPage> createState() => _NuevoPedidoPageState();
}

class _NuevoPedidoPageState extends State<NuevoPedidoPage> {
  final _cliente = TextEditingController();
  final _cantidad = TextEditingController();
  String _producto = productosCafe.first;

  @override
  void dispose() {
    _cliente.dispose();
    _cantidad.dispose();
    super.dispose();
  }

  Future<void> _agregar() async {
    final ok = await context.read<PedidosViewModel>().registrar(
      _cliente.text,
      _producto,
      _cantidad.text,
    );
    // Si no se guardó, el error ya lo muestra el ViewModel; no se navega.
    if (!ok || !mounted) return;
    // pop regresa a la lista, que ya se enteró del pedido nuevo.
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PedidosViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo pedido')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            key: const Key('cliente'),
            controller: _cliente,
            decoration: const InputDecoration(labelText: 'Cliente'),
          ),
          DropdownButtonFormField<String>(
            key: const Key('producto'),
            initialValue: _producto,
            decoration: const InputDecoration(labelText: 'Producto'),
            items: [
              for (final p in productosCafe)
                DropdownMenuItem(value: p, child: Text(p)),
            ],
            // Estado efímero: basta setState.
            onChanged: (p) => setState(() => _producto = p!),
          ),
          TextField(
            key: const Key('cantidad'),
            controller: _cantidad,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Cantidad'),
          ),
          const SizedBox(height: 16),
          if (vm.error != null)
            Text(
              vm.error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: vm.guardando ? null : _agregar,
            child: const Text('Agregar'),
          ),
        ],
      ),
    );
  }
}
```

**Por qué así:**

- `StatefulWidget` **solo** por el estado efímero: lo que se escribe en los campos y el producto elegido. Eso no le importa a nadie más, así que no va en el ViewModel.
- `dispose()` libera los `TextEditingController` (el script lo revisa).
- El Dropdown arranca en `productosCafe.first` y cambia con `setState`.
- `context.read` en `_agregar` (callback) y `context.watch` en `build` (para mostrar `error` y `guardando`).
- `if (!ok || !mounted) return;`: si no se guardó, se queda en el formulario mostrando el error; si la pantalla se cerró durante el `await`, no usa el `context` (evita *use_build_context_synchronously*).
- `Navigator.pop` **solo si se guardó**.
- `vm.guardando ? null : _agregar`: con `null` el botón se ve desactivado mientras guarda.
- `Key('cliente')`, `Key('producto')`, `Key('cantidad')` y el texto `'Agregar'` son los que buscan las pruebas.

**En clase:** `FormularioRegistro` de EcoTrack Meta (controlador, `dispose`, Dropdown con `setState`, `if (!guardado || !mounted) return;`). La diferencia: allá limpiaba el campo y mostraba un SnackBar; aquí hace `pop`.

**Comprueba:** ya compila todo. `flutter analyze lib` → `No issues found!` y `flutter run -d chrome` para probarla a mano.

---

### Paso 8 · Tu prueba

**Qué haces:** UNA prueba unitaria del ViewModel, con Preparar / Actuar / Comprobar.

**Archivo:** `cafe_utez/test/pedidos_view_model_test.dart`

```dart
// Prueba unitaria del ViewModel: sin pantalla y sin red.
//   flutter test

import 'package:cafe_utez/datos/memoria_pedido_repository.dart';
import 'package:cafe_utez/presentacion/pedidos_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('registrar con datos válidos guarda en el repositorio y avisa', () async {
    // Preparar
    final repositorio = MemoriaPedidoRepository();
    final vm = PedidosViewModel(repositorio);
    var avisos = 0;
    vm.addListener(() => avisos++);

    // Actuar
    final ok = await vm.registrar('Ana', 'Café', '2');

    // Comprobar
    expect(ok, isTrue);
    expect(vm.error, isNull);
    expect(vm.pedidos, hasLength(1));
    expect(vm.totalPiezas, 2);
    expect((await repositorio.todos()).single.cliente, 'Ana');
    expect(avisos, greaterThan(0));

    vm.dispose();
  });
}
```

**Por qué así:**

- **Exactamente un `test(...)`**: el script cuenta y exige 1.
- La línea clave es `repositorio.todos()`: demuestra que el ViewModel **sí delegó en la capa de datos**, no solo cambió su copia. (Haz el experimento: comenta el `await _repositorio.guardar(...)` del ViewModel y esta prueba debe fallar.)
- `addListener` + `avisos` comprueba que sí llamó a `notifyListeners()`.
- No necesita pantalla ni red: la lógica está en el ViewModel y el repo es en memoria.
- Esta prueba sí importa `MemoriaPedidoRepository`: el script solo revisa imports dentro de `lib/`, no de `test/`.

**En clase:** las pruebas de `etapa3_viewmodel_test.dart` del kit de EcoTrack Meta (mismo estilo con `addListener`).

**Comprueba:** `flutter test` → `All tests passed!`

---

### Paso 9 · Verificar con el kit

**Qué haces:** corres todo lo que usará el profe para calificar.

```bash
# dentro de cafe_utez/
flutter analyze lib                         # → No issues found!
flutter test                                # → All tests passed!

# desde la raíz del repo (donde está kit/)
cd ..
bash kit/verificar_practica.sh cafe_utez    # → Resultado: todo OK.
bash kit/autoevaluar.sh cafe_utez           # → Automático ... 90 / 90
```

**Resultado actual de esta app:**

```
  R1 Dominio ............................  15 / 15
  R2 Datos ..............................  10 / 10
  R3 ViewModel ..........................  25 / 25
  R4 Vistas, provider y navegación ......  25 / 25
  R5 Tu prueba pasa .....................  10 / 10
  Script de capas en OK .................   5 /  5
  ------------------------------------------------
  Automático ............................  90 / 90
```

- Si un renglón sale **PARCIAL**, el script te dice qué prueba falló: regresa al paso de esa capa.
- `autoevaluar.sh` trabaja sobre una **copia temporal**: no toca tu proyecto. Al final te dice dónde quedó la copia para que la borres.
- El kit **no se sube a GitHub** (`kit/` está en `.gitignore`). Si no lo tienes, sácalo de la rama del profe: `git checkout profesor -- kit && git restore --staged kit`.

**Prueba manual (para R6, "app que corre"):** `cd cafe_utez && flutter run -d chrome`, agrega un pedido inválido (ve el error), uno válido (regresa a la lista), cambia el producto en el Dropdown y entrega uno.

---

### Paso 10 · Entregar

```bash
cd cafe_utez
flutter clean                    # borra build/ y .dart_tool/ (el zip pesa mucho menos)
cd ..
zip -r MATRICULA_APELLIDO_cafe_utez.zip cafe_utez
```

Después de `flutter clean`, si quieres seguir trabajando: `cd cafe_utez && flutter pub get`.

---

## 5. Los 4 tipos de estado

| Tipo | Dónde vive | Ejemplo en la app | Cómo se avisa |
|---|---|---|---|
| **Efímero** | `State` del widget | texto de los campos, producto del Dropdown | `setState` |
| **Compartido** | ViewModel | `pedidos`, `error`, `guardando` | `notifyListeners()` |
| **Derivado** | getter del ViewModel | `totalPiezas` | no se guarda: se calcula |
| **Persistido** | repositorio | `_pedidos` (fuente de verdad) | el ViewModel relee `todos()` |

Es la misma tabla que llenaste en `docs/estado.md` de EcoTrack Meta.

---

## 6. Hoja de contratos

En el examen te darán **otra app con otros nombres**, pero con esta misma forma. Esto es lo que debe coincidir al carácter:

**Dominio:** `productosCafe = ['Café','Torta','Jugo','Galletas']`, `cantidadMaxima = 5`, `Pedido({required cliente, producto, cantidad})`.
`validarCliente`: vacío/espacios → `'Escribe el nombre del cliente'` · <3 letras → `'El nombre debe tener al menos 3 letras'` · si no `null`.
`validarCantidad`: `null` → `'Escribe la cantidad con número'` · fuera de 1–5 → `'La cantidad debe ser de 1 a 5'` · si no `null`.

**Datos:** `abstract class PedidoRepository { guardar(Pedido); entregar(int); todos(); }` · `MemoriaPedidoRepository` con lista privada y `List.unmodifiable`.

**ViewModel:** `PedidosViewModel(PedidoRepository)`, `pedidos = []`, `String? error`, `guardando = false`, `get totalPiezas`, `cargar()`, `registrar(cliente, producto, cantidadTexto) → Future<bool>`, `entregar(int)`, `limpiarError()`.

**main:** `CafeUtezApp({required PedidoRepository repositorio})`, `ChangeNotifierProvider` arriba, `home: const PedidosPage()`.

**Vistas:**

| Pantalla | Elemento | Contrato |
|---|---|---|
| PedidosPage | AppBar | `'Cafetería UTEZ'` |
| | Encabezado | `'Pedidos: N · Piezas: P'` |
| | Vacía | `'Sin pedidos'` |
| | Fila | title: producto · subtitle: `'Ana · x3'` |
| | Entregar | `IconButton` `Key('entregar_$i')` |
| | FAB | `Key('nuevo')` → `limpiarError()` + `push` |
| NuevoPedidoPage | AppBar | `'Nuevo pedido'` |
| | Campos | `Key('cliente')`, `Key('producto')` (Dropdown, arranca en el primero), `Key('cantidad')` |
| | Error | `Text` con el mensaje exacto |
| | Botón | `FilledButton 'Agregar'`, `null` si `guardando` |
| | Al agregar | `true` → `pop`; si no, se queda |

---

## 7. Errores frecuentes

| Ves | Causa | Arreglo |
|---|---|---|
| `ProviderNotFoundException` al abrir el form | provider dentro de `home` | súbelo arriba de `MaterialApp` |
| La lista no se actualiza | falta el último `notifyListeners()` o usaste `read` en build | `watch` en build; avisa al terminar |
| Botón siempre desactivado | `guardando` nunca vuelve a `false` | ponlo en `false` y avisa |
| *Tried to listen… outside of the widget tree* | `watch` en un callback | `read` en callbacks |
| *Vertical viewport was given unbounded height* | `ListView` en `Column` sin `Expanded` | envuélvelo en `Expanded` |
| Error viejo al reabrir el form | no llamas `limpiarError()` antes del push | llámalo en el FAB |
| *setState() called during build* | `limpiarError()` en `initState` | llámalo en el callback |
| *Target of URI doesn't exist: package:cafe_utez* | `name:` del pubspec distinto | `name: cafe_utez` |
| *use_build_context_synchronously* | `context` después de `await` | `if (!mounted) return;` |
| "se esperaba 1 prueba y hay 2" | quedó `widget_test.dart` | bórralo |
| `pub add provider --offline` falla | provider/nested no están en caché | `dart pub cache add` con internet (paso 0) |

---

## 8. Experimentos para entenderlo de verdad

- **Provider mal puesto:** mueve el `ChangeNotifierProvider` dentro de `home:` → hot restart → toca *Nuevo pedido* → `ProviderNotFoundException`. Regrésalo.
- **¿Tu prueba detecta errores?** Comenta `await _repositorio.guardar(...)` en el ViewModel → `flutter test` debe fallar.
- **Olvidar el último `notifyListeners()`** de `registrar`: el pedido se guarda pero la lista no se redibuja y el botón queda gris.
- **`watch` en un `onPressed`:** cambia un `read` por `watch` → error *Tried to listen… from outside of the widget tree*.

---

## 9. Preguntas de repaso

Contéstalas en voz alta señalando el código:

1. ¿Quién es la fuente de verdad de los pedidos? → El repositorio; el ViewModel tiene una copia que relee con `todos()`.
2. ¿Por qué `totalPiezas` es getter? → Es derivado; un campo podría desfasarse.
3. ¿Qué estado es efímero y cuál compartido? → Efímero: controladores y producto (`setState`). Compartido: `pedidos`, `error`, `guardando` (`notifyListeners`).
4. ¿ChangeNotifier vs provider? → ChangeNotifier **avisa**; provider **entrega** el ViewModel por el árbol y llama `dispose()`.
5. ¿watch vs read? → watch en build (se suscribe); read en callbacks (no se suscribe).
6. ¿Por qué el provider va arriba de MaterialApp? → Las rutas de `push` cuelgan del Navigator, no de `home`.
7. ¿Por qué `foundation.dart`? → El ViewModel no dibuja; `ChangeNotifier` vive ahí.
8. ¿Por qué recibe `PedidoRepository` y no `MemoriaPedidoRepository`? → Depender del contrato: repo falso en pruebas, API en producción.
9. Si mañana los datos vienen de una API, ¿qué cambias? → Un archivo nuevo en `datos/` que implemente el contrato + una línea en `main.dart`.
10. ¿Por qué tu prueba no necesita pantalla ni red? → La lógica está separada en ViewModel/dominio y el repo es en memoria.
11. ¿Qué pasa si olvidas el último `notifyListeners()`? → Se guarda pero nadie se entera; botón gris.
12. ¿Por qué `mounted` antes de `pop`? → La pantalla pudo cerrarse durante el `await`.
13. ¿Dónde vive "mínimo 3 letras"? → Solo en `validarCliente` (dominio).
14. ¿Qué patrones de la clase de Patrones usa la app? → Repository (`PedidoRepository`), Inyección de dependencias (constructores que reciben el repo), Observer (`ChangeNotifier`).

---

## 10. Plan de estudio y simulacro de 90 min

1. **Guiada (~2 h):** sigue la sección 4 leyendo cada archivo de `cafe_utez/lib` en orden. Por cada línea pregúntate *por qué está ahí*.
2. **Con apoyo (~1.5 h):** en otra carpeta repite los pasos 1 a 10 escribiendo tú el código, mirando solo la [hoja de contratos](#6-hoja-de-contratos). Si te atoras, mira el paso correspondiente. Corre `autoevaluar.sh`.
3. **Simulacro (90 min, sin internet, sin mirar):**

| Etapa | Paso de esta guía | Min | Acum. |
|---|---|---|---|
| 0 | Paso 1: crear proyecto + provider offline | 5 | 5 |
| 1 | Paso 2: dominio | 10 | 15 |
| 2 | Paso 3: datos | 8 | 23 |
| 3 | Paso 4: ViewModel | 17 | 40 |
| 4 | Pasos 5 y 6: main.dart + lista | 15 | 55 |
| 5 | Paso 7: formulario + navegación | 15 | 70 |
| 6 | Paso 8: tu prueba | 10 | 80 |
| 7 | Pasos 9 y 10: verificar + `flutter clean` + zip | 10 | 90 |

Si sacas 90/90 con tiempo de sobra, estás listo. Si pierdes puntos, `autoevaluar.sh` te dice en qué renglón: repite ese paso.

---

## Checklist antes de entregar

- [ ] `name: cafe_utez` y `provider` en dependencies
- [ ] `dominio/` y `datos/` sin imports de Flutter
- [ ] ViewModel: `ChangeNotifier`, `foundation.dart`, recibe el contrato
- [ ] Reglas solo en el dominio · derivado como getter
- [ ] `ChangeNotifierProvider` arriba de `MaterialApp`
- [ ] watch en build, read en callbacks
- [ ] push para abrir, pop solo si se guardó · `dispose()` en el form
- [ ] Textos y Key idénticos al contrato
- [ ] UNA prueba con Preparar/Actuar/Comprobar que consulta el repositorio
- [ ] Script OK · `flutter analyze lib` limpio · `flutter test` verde
- [ ] `flutter clean` + `zip -r MATRICULA_APELLIDO_cafe_utez.zip cafe_utez`

> Fuente: [Práctica guiada pre-examen — Unidad II (Notion)](https://spot-duke-7b6.notion.site/Pr-ctica-guiada-pre-examen-Unidad-II-Cafeter-a-UTEZ-411e73d41d938044972fd9a374ec97a8).
