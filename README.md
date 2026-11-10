# Cafetería UTEZ — Guía desde cero (Flutter · MVVM · provider)

> **¿Para quién es esta guía?** Para alguien que **nunca** ha hecho una app en Flutter. No necesitas saber nada antes: todo se explica con palabras simples. Síguela **en orden** y no te saltes pasos.

En este repo hay dos cosas:

- `cafe_utez/` → la app ya terminada (saca **90 / 90** en el kit del profe).
- Este `README.md` → la guía para entenderla y hacerla tú desde cero.

---

## Índice

**Parte 1 · Antes de empezar**
- [1.1 ¿Qué vamos a hacer?](#11-qué-vamos-a-hacer)
- [1.2 Qué necesitas](#12-qué-necesitas)
- [1.3 La terminal en 2 minutos](#13-la-terminal-en-2-minutos)
- [1.4 Ver la app terminada funcionando](#14-ver-la-app-terminada-funcionando)

**Parte 2 · Las ideas en palabras simples**
- [2.1 La app es como una cafetería de verdad](#21-la-app-es-como-una-cafetería-de-verdad)
- [2.2 Las 3 capas = 3 carpetas](#22-las-3-capas--3-carpetas)
- [2.3 Mini diccionario](#23-mini-diccionario)
- [2.4 Los 4 tipos de estado](#24-los-4-tipos-de-estado)

**Parte 3 · Paso a paso: hacer la app desde cero**
- [Cómo crear un archivo](#cómo-crear-un-archivo)
- [Paso 0 · Guardar provider para usarlo sin internet](#paso-0--guardar-provider-para-usarlo-sin-internet)
- [Paso 1 · Crear el proyecto](#paso-1--crear-el-proyecto)
- [Paso 2 · Dominio: las reglas](#paso-2--dominio-las-reglas)
- [Paso 3 · Datos: la libreta](#paso-3--datos-la-libreta)
- [Paso 4 · ViewModel: el encargado](#paso-4--viewmodel-el-encargado)
- [Paso 5 · main.dart: abrir la cafetería](#paso-5--maindart-abrir-la-cafetería)
- [Paso 6 · Pantalla 1: la lista](#paso-6--pantalla-1-la-lista)
- [Paso 7 · Pantalla 2: el formulario](#paso-7--pantalla-2-el-formulario)
- [Paso 8 · Tu prueba](#paso-8--tu-prueba)
- [Paso 9 · Revisar con el kit del profe](#paso-9--revisar-con-el-kit-del-profe)
- [Paso 10 · Entregar](#paso-10--entregar)

**Parte 4 · Para el examen**
- [4.1 Qué califica el profe](#41-qué-califica-el-profe)
- [4.2 Lo que viste en clase y dónde aparece aquí](#42-lo-que-viste-en-clase-y-dónde-aparece-aquí)
- [4.3 Hoja de contratos](#43-hoja-de-contratos)
- [4.4 Si algo sale mal](#44-si-algo-sale-mal)
- [4.5 Experimentos para entenderlo de verdad](#45-experimentos-para-entenderlo-de-verdad)
- [4.6 Preguntas de repaso](#46-preguntas-de-repaso)
- [4.7 Plan de estudio y simulacro de 90 min](#47-plan-de-estudio-y-simulacro-de-90-min)
- [4.8 Checklist antes de entregar](#48-checklist-antes-de-entregar)

---

# Parte 1 · Antes de empezar

## 1.1 ¿Qué vamos a hacer?

Una app para que la cafetería de la UTEZ **anote pedidos**. Tiene **dos pantallas**:

```
 PANTALLA 1 · Lista                  PANTALLA 2 · Formulario
┌──────────────────────────────┐    ┌──────────────────────────────┐
│ Cafetería UTEZ               │    │ ← Nuevo pedido               │
├──────────────────────────────┤    ├──────────────────────────────┤
│ Pedidos: 2 · Piezas: 5       │    │ Cliente   [ Ana            ] │
│                              │    │ Producto  [ Café         v ] │
│ (1) Café                [ok] │    │ Cantidad  [ 2              ] │
│     Ana · x2                 │    │                              │
│ (2) Torta               [ok] │    │ (aquí sale el error, si hay) │
│     Luis · x3                │    │                              │
│                              │    │          [ Agregar ]         │
│            [+ Nuevo pedido]  │    │                              │
└──────────────────────────────┘    └──────────────────────────────┘
```

- **+ Nuevo pedido** abre la pantalla 2.
- **Agregar** revisa los datos. Si están bien, guarda el pedido y regresa a la pantalla 1. Si están mal, muestra el error y se queda ahí.
- **[ok]** significa "ya se entregó": quita ese pedido de la lista.

**Las reglas de la cafetería:**

- Solo vende: **Café, Torta, Jugo y Galletas**.
- El nombre del cliente debe tener **al menos 3 letras**.
- La cantidad debe ser un número **del 1 al 5**.

**¿Por qué importa?** El examen será **una app con esta misma forma pero con otros nombres** (otro negocio, otras reglas). Si entiendes esta, puedes hacer aquella.

## 1.2 Qué necesitas

| Qué | Para qué | Cómo saber si ya lo tienes |
|---|---|---|
| **Flutter** | Es la herramienta con la que se hacen las apps. Trae el lenguaje **Dart**. | En la terminal: `flutter --version` debe mostrar un número de versión. |
| **Un editor** (VS Code o Android Studio) | Para escribir el código. Es como un Word para programar. | Ábrelo. |
| **Google Chrome** | Para ver la app funcionando en el navegador. | Ábrelo. |

> Si `flutter --version` dice *command not found* (o *no se reconoce*), Flutter no está instalado. Sigue la guía oficial: <https://docs.flutter.dev/get-started/install> y vuelve aquí.

## 1.3 La terminal en 2 minutos

La **terminal** es una ventana donde le escribes órdenes a la computadora en lugar de dar clics.

**Cómo abrirla:**

- **Mac:** `Cmd + Espacio` → escribe `Terminal` → Enter.
- **Windows:** abre **Git Bash** (los scripts del profe son de bash; en PowerShell no corren).
- **Dentro de VS Code:** menú *Terminal → New Terminal*. Así ya queda en la carpeta del proyecto.

**Las únicas 4 órdenes que necesitas saber:**

| Orden | Qué hace | Ejemplo |
|---|---|---|
| `cd carpeta` | **Entrar** a una carpeta | `cd cafe_utez` |
| `cd ..` | **Salir** a la carpeta de arriba | `cd ..` |
| `ls` | **Ver** qué hay en la carpeta donde estás | `ls` |
| `pwd` | **Saber** en qué carpeta estás | `pwd` |

**Cómo leer los comandos de esta guía:**

- Escribe (o copia y pega) **una línea a la vez** y presiona **Enter**.
- Lo que va después de `#` es una **nota para ti**. No hace falta escribirlo.
- Espera a que termine cada orden: sabrás que terminó porque aparece otra vez el cursor para escribir.

## 1.4 Ver la app terminada funcionando

Antes de hacerla, mírala funcionando para saber a dónde vas:

```bash
cd cafe_utez               # entra a la carpeta de la app
flutter pub get            # descarga lo que la app necesita (solo la primera vez)
flutter run -d chrome      # abre la app en Chrome (en Mac también: -d macos)
```

Con la app abierta, en la terminal puedes presionar:

| Tecla | Qué hace |
|---|---|
| `r` | **Recarga rápida**: aplica tus cambios de código sin cerrar la app |
| `R` | **Reinicio**: vuelve a arrancar la app desde cero (se borran los pedidos) |
| `q` | **Cerrar** la app |

**Prueba esto:** agrega un pedido con cliente `Al` (te dirá que faltan letras), luego uno con `Ana` y cantidad `2`, cambia el producto, y toca **[ok]** para entregarlo.

---

# Parte 2 · Las ideas en palabras simples

## 2.1 La app es como una cafetería de verdad

Piensa en cómo funciona una cafetería real. La app está organizada **igual**:

| En la cafetería real | En la app | Archivo |
|---|---|---|
| **Las reglas** pegadas en la pared: el menú, "máximo 5 piezas", "dime tu nombre". | **Dominio** | `lib/dominio/pedido.dart` |
| **La libreta** donde se apuntan los pedidos. | **Repositorio** (capa de datos) | `lib/datos/...` |
| **El encargado de la caja**: recibe el pedido, revisa las reglas, lo apunta en la libreta y **grita "¡pedido nuevo!"**. | **ViewModel** | `lib/presentacion/pedidos_view_model.dart` |
| **El pizarrón** que ven todos con los pedidos pendientes. | **Pantalla 1** (lista) | `lib/presentacion/pedidos_page.dart` |
| **La hoja** donde el cliente escribe su pedido. | **Pantalla 2** (formulario) | `lib/presentacion/nuevo_pedido_page.dart` |
| **El gancho** en la pared donde está el encargado, para que cualquiera lo encuentre. | **provider** | `lib/main.dart` |

Dos ideas más:

- **El contrato de la libreta.** Al encargado no le importa si la libreta es de papel, un cuaderno o una computadora. Solo necesita poder **apuntar**, **tachar** y **leer**. Eso es un **contrato**: una lista de lo que se debe poder hacer, sin decir cómo. Hoy usamos una "libreta en memoria" (se borra al cerrar la app); mañana podría ser internet, y el encargado ni se entera.
- **Escuchar vs. pedir.** El pizarrón está **pendiente** de lo que grita el encargado para actualizarse (eso es `watch`). La hoja de pedido solo lo **llama una vez** cuando tocas "Agregar" (eso es `read`).

## 2.2 Las 3 capas = 3 carpetas

```
lib/
├── dominio/        ← LAS REGLAS. Puro Dart, nada de pantallas.
├── datos/          ← LA LIBRETA. Guarda y lee pedidos.
└── presentacion/   ← LO QUE SE VE + el ViewModel que lo controla.
```

Cómo se conectan (las flechas significan "usa a"):

```
 Pantallas  ──usan──►  ViewModel  ──usa──►  Reglas (dominio)
 (lo que ves)          (encargado) ──usa──►  Contrato de la libreta (datos)
                                                   ▲
                                         MemoriaPedidoRepository
                                         (la libreta real; solo main.dart la conoce)
```

**¿Por qué separar todo?**

- Si cambias la libreta (memoria → internet), solo cambias **un archivo** de `datos/` y una línea de `main.dart`.
- Puedes **probar** al encargado sin abrir pantallas (eso hace tu prueba del paso 8).
- El profe **revisa** que esté separado: es parte de la calificación.

**Las reglas de oro** (el script del profe las revisa):

1. `dominio/` y `datos/` **no usan nada de Flutter** (ni pantallas, ni botones).
2. El ViewModel **no dibuja** nada.
3. Las pantallas **no tocan la libreta**: todo lo piden al ViewModel.
4. Solo `main.dart` sabe **cuál** libreta se usa.

## 2.3 Mini diccionario

No te lo aprendas de memoria: regresa aquí cuando veas una palabra que no entiendes.

**Palabras de Dart (el lenguaje):**

| Palabra | Qué significa |
|---|---|
| `// texto` | **Comentario**: nota para humanos. La computadora lo ignora. |
| `import '...';` | "Trae lo que hay en este otro archivo para poder usarlo aquí". |
| `class Algo { }` | Un **molde**. Con el molde `Pedido` se crean muchos pedidos. |
| `String` | Texto. Ejemplo: `'Ana'`. |
| `int` | Número entero. Ejemplo: `3`. |
| `bool` | Verdadero o falso: `true` / `false`. |
| `List<Pedido>` | Una lista de pedidos. Se escribe con corchetes: `['Café', 'Torta']`. |
| `null` | "Nada", "vacío", "no hay". |
| `String?` | El `?` significa "puede ser texto **o** `null`". |
| `const` | Valor fijo que **nunca** cambia. |
| `final` | Se pone una vez y ya **no se puede cambiar**. |
| `required` | "Obligatorio": no puedes crear el objeto sin darlo. |
| `return` | "Responde esto y termina la función". |
| `_algo` (con guion bajo) | **Privado**: solo se puede usar dentro de su propio archivo. |
| `Future` | Una **promesa**: "el resultado llega después" (como un ticket de turno). |
| `async` / `await` | `async` marca una función que tarda; `await` significa "espera aquí a que termine". |
| `@override` | "Aquí estoy cumpliendo una parte del contrato". |
| `a ?? b` | "Usa `a`; si `a` es `null`, usa `b`". |
| `condicion ? x : y` | "Si se cumple la condición, `x`; si no, `y`". |
| `algo!` | "Te aseguro que esto **no** es `null`". |

**Palabras de Flutter (las pantallas):**

| Palabra | Qué significa |
|---|---|
| **Widget** | Cualquier pieza de la pantalla: un texto, un botón, una pantalla completa. Todo es widget. |
| `StatelessWidget` | Widget **sin memoria propia**: solo dibuja lo que le dan. |
| `StatefulWidget` | Widget **con memoria propia** (por ejemplo, lo que llevas escrito en un campo). |
| `build` | La función que dice **cómo se dibuja** el widget. |
| `setState` | "Cambié algo de mi memoria; vuelve a dibujarme". |
| `Scaffold` | El esqueleto de una pantalla: barra de arriba, cuerpo y botón flotante. |
| `Key('nombre')` | Una etiqueta para que las pruebas encuentren ese widget. |
| `Navigator.push` | **Abrir** una pantalla encima de la actual. |
| `Navigator.pop` | **Cerrar** la pantalla actual y regresar a la de abajo. |

**Palabras de la materia:**

| Palabra | Qué significa |
|---|---|
| **MVVM** | Forma de organizar la app: **M**odelo (reglas y datos), **V**ista (pantallas), **V**iew**M**odel (el encargado en medio). |
| **ChangeNotifier** | Lo que le da al ViewModel la capacidad de **avisar** ("¡cambié!") con `notifyListeners()`. |
| **provider** | Librería que **cuelga** el ViewModel arriba de todas las pantallas para que cualquiera lo encuentre. |
| `context.watch` | "Estoy **pendiente** del ViewModel; redibújame cuando avise". Se usa para **mostrar**. |
| `context.read` | "Dame el ViewModel una vez, **no** me suscribas". Se usa para **actuar** (al tocar un botón). |
| **Repositorio** | La libreta: el lugar donde se guardan los datos. |
| **Contrato** (`abstract class`) | La lista de lo que el repositorio **debe** saber hacer, sin decir cómo. |
| **Inyección de dependencias** | Darle a alguien desde fuera lo que necesita (al encargado se le **da** la libreta; no la fabrica él). |
| **Prueba** (test) | Un programa que revisa automáticamente que otro programa funcione. |
| **Librería / paquete** | Código hecho por otras personas que usamos en nuestra app (como `provider`). |

## 2.4 Los 4 tipos de estado

**Estado** = datos que pueden cambiar mientras usas la app. Hay 4 tipos y cada uno vive en un lugar distinto:

| Tipo | En palabras simples | Ejemplo en la app | Dónde vive |
|---|---|---|---|
| **Efímero** | Solo le importa a **una** pantalla y se olvida al cerrarla. | Lo que vas escribiendo en el formulario; el producto elegido. | En el `State` del formulario (`setState`). |
| **Compartido** | Lo necesitan **varias** pantallas. | La lista de `pedidos`, el `error`, si está `guardando`. | En el ViewModel (`notifyListeners`). |
| **Derivado** | **No se guarda**: se calcula a partir de otro dato. | `totalPiezas` (se suma de los pedidos). | Un `get` del ViewModel. |
| **Persistido** | La **fuente de verdad**: lo que "de verdad" está guardado. | `_pedidos` dentro de la libreta. | En el repositorio. |

---

# Parte 3 · Paso a paso: hacer la app desde cero

En cada paso encontrarás:

- **En palabras simples**: qué estás haciendo y para qué.
- **Haz esto**: las acciones concretas.
- **El código**: cópialo tal cual (los textos deben ser **idénticos**, con acentos).
- **Qué significa cada parte**: la explicación.
- **Lo viste en clase**: dónde hiciste algo igual.
- **Comprueba que vas bien**: cómo saber que no te equivocaste.

Vamos **de abajo hacia arriba**: reglas → libreta → encargado → arranque → pantallas → prueba.

### Cómo crear un archivo

Abre la carpeta `cafe_utez` en tu editor:

- **VS Code:** *File → Open Folder…* → elige `cafe_utez`. En el panel de la izquierda, clic derecho sobre la carpeta (por ejemplo `lib/dominio`) → *New File* → escribe el nombre (por ejemplo `pedido.dart`) → Enter. Pega el código y guarda con `Cmd + S` (Mac) o `Ctrl + S` (Windows).
- **Android Studio:** *File → Open* → elige `cafe_utez`. En el panel de la izquierda, clic derecho sobre la carpeta → *New → File* → escribe el nombre → Enter. Pega el código y guarda.

> El nombre del archivo y la carpeta deben ser **exactamente** los que dice cada paso. Las pruebas del profe buscan esos nombres.

---

### Paso 0 · Guardar provider para usarlo sin internet

**En palabras simples:** en el examen no hay internet. `provider` es una librería que se descarga de internet, así que la guardas **antes**, una sola vez, en la memoria de tu computadora.

**Haz esto** (con internet, días antes del examen):

```bash
dart pub cache add provider --version 6.1.5+1
dart pub cache add nested --version 1.0.0
```

**Qué significa:** `dart pub cache add` = "descarga este paquete y guárdalo en mi computadora". `nested` es una pieza que `provider` necesita para funcionar.

**Comprueba que vas bien:** cada orden termina sin la palabra *error*.

---

### Paso 1 · Crear el proyecto

**En palabras simples:** Flutter te arma la carpeta base de la app. Luego le agregas `provider` y creas las 3 carpetas de las capas.

**Haz esto** (en la terminal, en la carpeta donde quieras tu proyecto):

```bash
flutter create --empty --offline --org mx.edu.utez cafe_utez
cd cafe_utez
flutter pub add provider --offline
mkdir -p lib/dominio lib/datos lib/presentacion test
```

**Qué significa cada orden:**

| Orden | Qué hace |
|---|---|
| `flutter create ... cafe_utez` | Crea la carpeta `cafe_utez` con un proyecto de Flutter adentro. |
| `--empty` | Lo crea **vacío** (sin el ejemplo del contador y **sin** `test/widget_test.dart`, que estorbaría porque el profe pide UNA sola prueba). |
| `--offline` | Sin internet. |
| `--org mx.edu.utez` | El "apellido" de la app (identifica a la escuela). |
| `cd cafe_utez` | Entra a la carpeta nueva. |
| `flutter pub add provider --offline` | Agrega la librería `provider` al proyecto (la que guardaste en el paso 0). |
| `mkdir -p ...` | Crea las carpetas `lib/dominio`, `lib/datos`, `lib/presentacion` y `test`. |

**Importante:** el nombre **tiene** que ser `cafe_utez`. Las pruebas del profe empiezan con `import 'package:cafe_utez/...'`; con otro nombre, nada funciona.

**Comprueba que vas bien:** abre el archivo `pubspec.yaml` (es la "ficha" del proyecto: nombre y librerías). Debe decir `name: cafe_utez` y, debajo de `dependencies:`, la línea `provider: ^6.1.5+1`.

> **Si algún día falta una plataforma** (error *This application is not configured to build on the web*), dentro de `cafe_utez` corre:
> `flutter create --org mx.edu.utez --project-name cafe_utez --platforms=web,macos .` y después `rm -f test/widget_test.dart README.md`.

---

### Paso 2 · Dominio: las reglas

**En palabras simples:** escribes las reglas de la pared: qué se vende, el máximo de piezas, cómo es un pedido y cómo se revisa que el nombre y la cantidad estén bien.

**Haz esto:** crea el archivo `lib/dominio/pedido.dart` y pega:

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

**Qué significa cada parte:**

- `const productosCafe = [...]` → la lista del menú. Es `const` porque **nunca cambia**: no es estado.
- `const cantidadMaxima = 5;` → el máximo de piezas.
- `class Pedido { ... }` → el **molde** de un pedido: todo pedido tiene `cliente` (texto), `producto` (texto) y `cantidad` (número).
- `required this.cliente` → para crear un pedido es **obligatorio** dar el cliente. Así se crea uno: `Pedido(cliente: 'Ana', producto: 'Café', cantidad: 2)`.
- `final` → una vez creado el pedido, no se puede modificar.
- `String? validarCliente(String cliente)` → una **función**: recibe el nombre y responde con un texto de error **o** con `null` (el `?`).
  - `cliente.trim()` → quita los espacios de los lados. Así `' Al '` cuenta como 2 letras, no 4.
  - `.isEmpty` → "está vacío". `.length` → "cuántas letras tiene".
  - Primero revisa si está vacío y **después** si es muy corto. El orden importa.
  - `return null;` → "no hay error, el nombre está bien".
- `String? validarCantidad(int? cantidad)` → igual, pero con la cantidad.
  - Recibe `int?` porque si escribieron `"dos"` no hay número: llega `null`.
  - `cantidad < 1 || cantidad > cantidadMaxima` → "menor que 1 **o** (`||`) mayor que 5".
  - `$cantidadMaxima` dentro del texto → mete el valor `5`. Queda: `'La cantidad debe ser de 1 a 5'`.

**¿Por qué las reglas responden con el mensaje y no con verdadero/falso?** Porque así la pantalla solo tiene que **mostrar** el texto tal cual; no decide nada.

**Lo viste en clase:** `lib/dominio/consumo.dart` de EcoTrack Meta (`laboratoriosUtez`, `Consumo`, `validarLitros`).

**Comprueba que vas bien:** en la terminal (dentro de `cafe_utez`): `flutter analyze lib` → debe decir `No issues found!`

---

### Paso 3 · Datos: la libreta

**En palabras simples:** primero escribes el **contrato** de la libreta (qué debe saber hacer: guardar, entregar, darme todos). Luego haces una libreta real que **cumple** el contrato y guarda los pedidos en una lista.

**Haz esto:** crea `lib/datos/pedido_repository.dart`:

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

Y crea `lib/datos/memoria_pedido_repository.dart`:

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

**Qué significa cada parte:**

- `import '../dominio/pedido.dart';` → "trae el molde `Pedido`". Los `..` significan "sube una carpeta" (de `datos/` a `lib/`).
- `abstract class PedidoRepository` → el **contrato**. Solo dice **qué** se puede hacer, no **cómo**. No se puede usar solo: alguien tiene que cumplirlo.
- `Future<void> guardar(Pedido pedido);` → "guardar un pedido; termina después y no regresa nada" (`void` = nada).
- `Future<List<Pedido>> todos();` → "después te doy la lista de pedidos".
- **¿Por qué `Future` si es una lista que responde al instante?** Porque una libreta real (internet, base de datos) **tarda**. Si el contrato ya está preparado para esperar, cambiar de libreta no rompe nada.
- `class MemoriaPedidoRepository implements PedidoRepository` → "yo **cumplo** el contrato".
- `final List<Pedido> _pedidos = [];` → la lista donde de verdad están los pedidos. El `_` la hace **privada**: nadie de fuera la puede tocar. Es la **fuente de verdad**.
- `@override` → "esta función es la que el contrato pedía".
- `_pedidos.add(pedido)` → agrega al final. `_pedidos.removeAt(indice)` → quita el de esa posición (el primero es la posición `0`).
- `List.unmodifiable(_pedidos)` → regresa una **copia de solo lectura**. Si alguien intenta agregarle algo, la app marca error. Así nadie cambia la libreta "por fuera".

**Lo viste en clase:** `consumo_repository.dart` y `memoria_consumo_repository.dart` de EcoTrack Meta, y el **Caso D (patrón Repository)** de la actividad de Patrones.

**Comprueba que vas bien:** `flutter analyze lib` → `No issues found!`

---

### Paso 4 · ViewModel: el encargado

**En palabras simples:** el encargado guarda lo que todas las pantallas necesitan saber (los pedidos, si hay error, si está guardando). Cuando le piden registrar un pedido: revisa las reglas, lo apunta en la libreta, vuelve a leer la libreta y **avisa** a todos. Es la pieza que más puntos vale (25).

**Haz esto:** crea `lib/presentacion/pedidos_view_model.dart`:

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

**Qué significa cada parte:**

- `import 'package:flutter/foundation.dart';` → trae `ChangeNotifier`. **No** se importa `material.dart` (eso es para dibujar, y el encargado no dibuja) ni `provider` (al encargado no le importa quién lo cuelga).
- `class PedidosViewModel extends ChangeNotifier` → el encargado **hereda** la capacidad de avisar.
- `PedidosViewModel(this._repositorio);` → para crear al encargado **hay que darle** una libreta. Recibe el **contrato** (`PedidoRepository`), no una libreta específica. Así el profe le puede dar su libreta espía en las pruebas.
- `pedidos`, `error`, `guardando` → lo que las dos pantallas necesitan saber (estado **compartido**).
- `int get totalPiezas => ...` → **no se guarda**: se calcula cada vez sumando las cantidades (estado **derivado**). `fold(0, ...)` = "empieza en 0 y ve sumando la cantidad de cada pedido".
- `cargar()` → al abrir la app, lee lo que haya en la libreta y avisa.
- `notifyListeners()` → **el grito**: "¡cambié!". Todas las pantallas que están pendientes (`watch`) se vuelven a dibujar.

**`registrar`, paso por paso** (es lo que pasa al tocar **Agregar**):

1. `int.tryParse(cantidadTexto.trim())` → intenta convertir el texto en número. `"3"` → `3`. `"dos"` → `null`.
2. `validarCliente(cliente) ?? validarCantidad(cantidad)` → revisa el nombre; **si está bien** (`null`), revisa la cantidad. Se queda con el primer error que encuentre.
3. **Si hay error:** lo guarda en `error`, avisa y responde `false` ("no se guardó"). **No toca la libreta.**
4. **Si todo está bien:** `guardando = true`, borra el error viejo y avisa. Mientras tanto el botón **Agregar** se desactiva.
5. `await _repositorio.guardar(...)` → apunta el pedido en la libreta y **espera** a que termine. Usa `cliente.trim()` para guardar `'Ana'` y no `'  Ana  '`. El `cantidad!` significa "ya revisé que no es `null`".
6. `pedidos = await _repositorio.todos();` → **vuelve a leer la libreta** (la fuente de verdad). No hace `pedidos.add(...)` por su cuenta.
7. `guardando = false`, avisa y responde `true`. **Si olvidas este último aviso**, el botón se queda gris para siempre y la lista no se entera.

- `limpiarError()` → borra el error y avisa. Se usa antes de abrir el formulario para que no salga el error de la vez anterior.
- `entregar(indice)` → tacha el pedido en la libreta, vuelve a leerla y avisa.

**Lo viste en clase:** `ConsumosViewModel` de EcoTrack Meta (su `guardar` es casi igual a `registrar`). Y el **Caso E (patrón Observer)** de Patrones: avisar a varios sin nombrarlos.

**Comprueba que vas bien:** `flutter analyze lib` → `No issues found!`

---

### Paso 5 · main.dart: abrir la cafetería

**En palabras simples:** aquí arranca la app. Eliges **qué libreta** se usa (la de memoria), creas al encargado y lo **cuelgas en el gancho** (provider) para que todas las pantallas lo encuentren.

**Haz esto:** abre `lib/main.dart` (ya existe porque lo creó Flutter), **borra todo** lo que tiene y pega:

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

**Qué significa cada parte:**

- `void main()` → **aquí empieza todo** cuando abres la app.
- `runApp(CafeUtezApp(repositorio: MemoriaPedidoRepository()))` → "muestra la app y dale la libreta de memoria". Es el **único** lugar donde se nombra `MemoriaPedidoRepository`.
- `class CafeUtezApp extends StatelessWidget` → la app completa es un widget.
- `required this.repositorio` → la app **recibe** la libreta desde fuera. Así las pruebas del profe pueden arrancarla con **su** libreta espía: `CafeUtezApp(repositorio: RepositorioEspia())`.
- `ChangeNotifierProvider<PedidosViewModel>(...)` → **el gancho**. Cuelga al encargado para que cualquier pantalla de abajo lo encuentre.
  - `create: (_) => PedidosViewModel(repositorio)..cargar()` → "crea al encargado con esta libreta y pídele que cargue". Los dos puntos `..` hacen que se llame a `cargar()` pero que se entregue **el encargado** (no la promesa de `cargar`).
  - El gancho también **limpia** al encargado cuando la app se cierra; tú no tienes que hacerlo.
- `child: MaterialApp(...)` → el marco de toda la app: título, colores y el sistema para cambiar de pantalla.
- `home: const PedidosPage()` → la primera pantalla que se ve.

**¿Por qué el gancho va ARRIBA de `MaterialApp`?** Cuando abres el formulario con `push`, Flutter lo pone **dentro de `MaterialApp`**, al lado de la pantalla 1, no dentro de ella. Si el gancho estuviera dentro de la pantalla 1, el formulario no lo encontraría y la app truena con `ProviderNotFoundException`.

**Lo viste en clase:** `AppProvider` en `b_provider.dart` + `main.dart` de EcoTrack Meta.

**Comprueba que vas bien:** todavía **no** compila: faltan las pantallas (pasos 6 y 7). Es normal; sigue.

---

### Paso 6 · Pantalla 1: la lista

**En palabras simples:** el pizarrón. Muestra cuántos pedidos y piezas hay, la lista de pedidos con su botón de entregar, y el botón para abrir el formulario. No tiene memoria propia: todo lo saca del encargado.

**Haz esto:** crea `lib/presentacion/pedidos_page.dart`:

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

**Qué significa cada parte** (de arriba hacia abajo, como se ve en la pantalla):

| Código | Qué es en la pantalla |
|---|---|
| `final vm = context.watch<PedidosViewModel>();` | "Busca al encargado en el gancho y **quédate pendiente** de él". Cada vez que grite, esta pantalla se redibuja sola. |
| `Scaffold(...)` | El esqueleto: barra de arriba (`appBar`), cuerpo (`body`) y botón flotante (`floatingActionButton`). |
| `AppBar(title: const Text('Cafetería UTEZ'))` | La barra de arriba con el título. |
| `Column(children: [...])` | Pone las cosas **una debajo de otra**. |
| `Padding(...)` + `Text('Pedidos: ... · Piezas: ...')` | El encabezado con un margen de 16 alrededor. `${...}` mete valores dentro del texto. |
| `Expanded(...)` | "Ocupa todo el espacio que sobre". Sin esto, la lista no sabe qué tan alta ser y la app truena. |
| `vm.pedidos.isEmpty ? ... : ...` | "Si no hay pedidos, muestra `Sin pedidos`; si hay, muestra la lista". |
| `ListView.builder(...)` | La lista. `itemCount` = cuántas filas. `itemBuilder` = cómo se dibuja la fila número `i` (empieza en 0). |
| `ListTile(...)` | Una fila: `leading` (círculo con el número), `title` (producto), `subtitle` (`Ana · x2`), `trailing` (botón a la derecha). |
| `IconButton(key: Key('entregar_$i'), ...)` | El botón de entregar. La `Key` es la etiqueta para que las pruebas lo encuentren (`entregar_0`, `entregar_1`...). |
| `onPressed: () => context.read<...>().entregar(i)` | Al tocarlo: "encargado, entrega el pedido `i`". Aquí se usa `read`, **no** `watch`. |
| `FloatingActionButton.extended(key: const Key('nuevo'), ...)` | El botón flotante **+ Nuevo pedido**. |
| `limpiarError()` y luego `Navigator.push(...)` | Al tocarlo: borra el error viejo y **abre** el formulario encima. |

**La regla más importante de esta pantalla:**

- **`watch` en `build`** → para **mostrar** (y redibujarse cuando cambie algo).
- **`read` en `onPressed`** → para **actuar** (pedirle algo al encargado una vez). Si pones `watch` dentro de un `onPressed`, la app truena.

**Lo viste en clase:** `ListaHistorial` + `HistorialProvider` de EcoTrack Meta. Allá estaban en dos clases separadas; aquí van juntas porque el script del profe busca el `watch` y el `read` dentro de este mismo archivo.

---

### Paso 7 · Pantalla 2: el formulario

**En palabras simples:** la hoja de pedido. Tiene tres campos (cliente, producto, cantidad), un lugar para el error y el botón **Agregar**. Esta pantalla **sí** tiene memoria propia: lo que llevas escrito y el producto que elegiste. Eso no le importa a nadie más, por eso no va en el encargado.

**Haz esto:** crea `lib/presentacion/nuevo_pedido_page.dart`:

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

**Qué significa cada parte:**

- **Dos clases:** `NuevoPedidoPage` (el widget) y `_NuevoPedidoPageState` (**su memoria**). Así funcionan todos los `StatefulWidget`.
- **La memoria de la pantalla** (estado efímero):
  - `_cliente` y `_cantidad` son `TextEditingController`: "lectores" de lo que se escribe en cada campo. `_cliente.text` es el texto escrito.
  - `_producto` es el producto elegido. Empieza en el primero del menú (`productosCafe.first` = `'Café'`).
- `dispose()` → **limpieza** cuando la pantalla se cierra: libera los lectores para no desperdiciar memoria. El script del profe revisa que exista.
- `_agregar()` → lo que pasa al tocar **Agregar**:
  1. `context.read<PedidosViewModel>().registrar(...)` → le pasa los tres datos al encargado y **espera** su respuesta (`true` o `false`).
  2. `if (!ok || !mounted) return;` → "si **no** se guardó, **o** si la pantalla ya se cerró, no hagas nada más". Si no se guardó, el error ya se ve en pantalla.
  3. `Navigator.pop(context);` → **cierra** el formulario y regresa a la lista (que ya se enteró del pedido nuevo).
- En `build`:
  - `context.watch<PedidosViewModel>()` → pendiente del encargado, para mostrar el `error` y saber si está `guardando`.
  - `TextField(key: const Key('cliente'), ...)` → campo de texto para el cliente.
  - `DropdownButtonFormField` → la lista desplegable. `for (final p in productosCafe)` crea una opción por cada producto. `onChanged` se ejecuta al elegir uno y con `setState` guarda la elección en la memoria de la pantalla.
  - `keyboardType: TextInputType.number` → en el celular abre el teclado de números.
  - `if (vm.error != null) Text(...)` → el texto del error **solo aparece si hay error**, en color rojo.
  - `FilledButton(onPressed: vm.guardando ? null : _agregar, ...)` → si está guardando, `onPressed` es `null` y el botón se ve **desactivado**; si no, al tocarlo llama a `_agregar`.

**Lo viste en clase:** `FormularioRegistro` de EcoTrack Meta (lectores de texto, `dispose`, Dropdown con `setState`, `if (!guardado || !mounted) return;`). La diferencia: allá limpiaba el campo y mostraba un aviso; aquí cierra la pantalla con `pop`.

**Comprueba que vas bien:** ahora sí compila todo.

```bash
flutter analyze lib        # → No issues found!
flutter run -d chrome      # pruébala a mano como en la sección 1.4
```

---

### Paso 8 · Tu prueba

**En palabras simples:** una prueba es un pequeño programa que **revisa solo** que tu encargado funcione, sin abrir pantallas. Se escribe en tres partes: **Preparar** (armar lo necesario), **Actuar** (hacer la acción) y **Comprobar** (revisar el resultado). El profe pide **exactamente una**.

**Haz esto:** crea `test/pedidos_view_model_test.dart` (ojo: en la carpeta `test`, **no** en `lib`):

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

**Qué significa cada parte:**

- `test('nombre de la prueba', () async { ... })` → define **una** prueba. El script del profe cuenta que haya exactamente una.
- **Preparar:** crea una libreta, crea al encargado con esa libreta, y con `addListener` cuenta cuántas veces grita (`avisos++` suma 1 cada vez).
- **Actuar:** registra a Ana con 2 cafés.
- **Comprobar:** `expect(valor, loQueEspero)` significa "aseguro que `valor` sea `loQueEspero`; si no, la prueba **falla**".

| Línea | Qué revisa |
|---|---|
| `expect(ok, isTrue);` | Que respondió "sí se guardó". |
| `expect(vm.error, isNull);` | Que no quedó ningún error. |
| `expect(vm.pedidos, hasLength(1));` | Que el encargado tiene 1 pedido. |
| `expect(vm.totalPiezas, 2);` | Que el total calculado es 2. |
| `expect((await repositorio.todos()).single.cliente, 'Ana');` | **La más importante:** que el pedido **sí llegó a la libreta**, no solo a la copia del encargado. |
| `expect(avisos, greaterThan(0));` | Que el encargado **sí gritó** (llamó a `notifyListeners`). |

- `vm.dispose();` → limpia al encargado al terminar.
- Aquí **sí** se puede usar `MemoriaPedidoRepository`: la regla de "solo en `main.dart`" aplica a `lib/`, no a `test/`.

**Lo viste en clase:** las pruebas de `etapa3_viewmodel_test.dart` del kit de EcoTrack Meta (mismo estilo con `addListener`).

**Comprueba que vas bien:** `flutter test` → debe terminar con `All tests passed!`

---

### Paso 9 · Revisar con el kit del profe

**En palabras simples:** el profe califica con unos scripts automáticos (el **kit**). Córrelos tú antes para saber tu calificación.

**Si no tienes el kit:** está en la rama `profesor` de este repo y **no se sube a GitHub** (`kit/` está en `.gitignore`). Para sacarlo, desde la raíz del repo:

```bash
git checkout profesor -- kit && git restore --staged kit
```

**Haz esto:**

```bash
# dentro de cafe_utez/
flutter analyze lib                         # → No issues found!
flutter test                                # → All tests passed!

# sal a la raíz del repo (donde está la carpeta kit/)
cd ..
bash kit/verificar_practica.sh cafe_utez    # → Resultado: todo OK.
bash kit/autoevaluar.sh cafe_utez           # → Automático ... 90 / 90
```

**Qué hace cada uno:**

- `verificar_practica.sh` → **lee** tu código y revisa que las capas estén separadas, que uses `watch`/`read`, `push`/`pop`, que haya una sola prueba, etc. Cada renglón dice `OK` o `FALTA`.
- `autoevaluar.sh` → hace una **copia** de tu proyecto (no toca el tuyo), corre todo y te da los puntos. Tarda un par de minutos.

**Así se ve con esta app:**

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

- Si un renglón sale **PARCIAL**, abajo dice qué prueba falló. Regresa al paso de esa capa (R1 = paso 2, R2 = paso 3, R3 = paso 4, R4 = pasos 5 a 7).
- Al final dice dónde quedó la copia temporal: puedes borrarla.

**Prueba a mano** (el profe revisa que la app corra): `cd cafe_utez && flutter run -d chrome` y repite lo de la sección 1.4.

---

### Paso 10 · Entregar

**En palabras simples:** borras los archivos que Flutter genera solo (pesan mucho) y comprimes la carpeta en un `.zip`.

```bash
cd cafe_utez
flutter clean                    # borra build/ y .dart_tool/ (archivos que se regeneran solos)
cd ..
zip -r MATRICULA_APELLIDO_cafe_utez.zip cafe_utez
```

- Cambia `MATRICULA_APELLIDO` por tu matrícula y apellido.
- En Windows, si no tienes `zip`: clic derecho en la carpeta `cafe_utez` → *Enviar a → Carpeta comprimida*.
- Si después quieres seguir trabajando: `cd cafe_utez && flutter pub get`.

---

# Parte 4 · Para el examen

## 4.1 Qué califica el profe

El repo del profe (rama `profesor`) **no trae código**: trae el kit con el que califica. Todo lo que pide sale de ahí.

| Renglón | Puntos | Qué revisa | Paso |
|---|---|---|---|
| R1 Dominio | 15 | Menú, máximo, mensajes exactos de `validarCliente` y `validarCantidad` | 2 |
| R2 Datos | 10 | `guardar`, `todos`, `entregar`; que `todos()` no deje modificar la lista | 3 |
| R3 ViewModel | 25 | `ChangeNotifier`, `cargar`, `registrar` (bien / mal / guardando), `totalPiezas`, `limpiarError` | 4 |
| R4 Vistas | 25 | Textos, `Key`s, abrir/cerrar pantallas, Dropdown, entregar, que no reaparezca el error viejo | 5 a 7 |
| R5 Tu prueba | 10 | Que `test/pedidos_view_model_test.dart` pase | 8 |
| Script de capas | 5 | `verificar_practica.sh` en "todo OK" | 9 |
| R6 Docente | 10 | Revisión a mano: calidad de tu prueba, que la app corra, código limpio | — |

> **Los textos y `Key`s deben ser idénticos**, con acentos y el punto medio `·`. Las pruebas buscan `'Pedidos: 0 · Piezas: 0'`; si escribes `'Pedidos: 0 - Piezas: 0'`, pierdes puntos aunque la app "funcione".

## 4.2 Lo que viste en clase y dónde aparece aquí

La Cafetería es **la misma receta que EcoTrack Meta** (U1-S03-A02, variante B · provider) con otros nombres y una pantalla que se abre con `push`.

| En clase (EcoTrack Meta) | En el examen (Cafetería UTEZ) | Qué es |
|---|---|---|
| `laboratoriosUtez` | `productosCafe` | Constante del dominio (no es estado) |
| `Consumo` | `Pedido` | Entidad `const` con campos `final` |
| `validarLitros(double?)` | `validarCliente(String)` y `validarCantidad(int?)` | Reglas: regresan el mensaje o `null` |
| `ConsumoRepository` | `PedidoRepository` | Contrato `abstract class` |
| `MemoriaConsumoRepository` | `MemoriaPedidoRepository` | Lista privada + `List.unmodifiable` |
| `ConsumosViewModel` | `PedidosViewModel` | `extends ChangeNotifier`, recibe el contrato |
| `guardar(lab, litrosTexto)` | `registrar(cliente, producto, cantidadTexto)` | Valida → guarda → relee `todos()` → avisa |
| `get total` | `get totalPiezas` | Estado derivado |
| `AppProvider` en `b_provider.dart` | `CafeUtezApp` en `main.dart` | `ChangeNotifierProvider` arriba de `MaterialApp` |
| `FormularioRegistro` | `NuevoPedidoPage` | Stateful por estado efímero, `dispose()`, Dropdown |
| `ListaHistorial` | `PedidosPage` | Lista + total |
| `RegistroProvider`, `HistorialProvider` | Las dos páginas | `watch` para mostrar, `read` para actuar |

**Patrones (actividad de Patrones de diseño):**

| Caso en clase | Patrón | Dónde está aquí |
|---|---|---|
| Caso D · "Ocultar de dónde salen los datos" | **Repository** | `PedidoRepository` + `MemoriaPedidoRepository` |
| Caso B · "Entregar desde fuera el objeto del que se depende" | **Inyección de dependencias** | `PedidosViewModel(repositorio)` y `CafeUtezApp(repositorio: ...)` |
| Caso E · "Avisar a varios interesados sin nombrarlos" | **Observer** | `ChangeNotifier` + `notifyListeners()` + `watch` |

**Lo que vimos en clase pero aquí NO se usa:**

- **Variante A** (ChangeNotifier puro, `ListenableBuilder`, pasar `vm` por constructor): el script del profe la marca como FALTA.
- **riverpod**: el kit pide `provider`.
- **Vistas tontas en un `vistas.dart` aparte**: aquí cada página usa `watch`/`read` directamente, porque ahí lo busca el script.
- **Lo nuevo respecto a EcoTrack:** dos pantallas con `push`/`pop` (allá eran pestañas), borrar un elemento (`entregar`) y `limpiarError()`.

## 4.3 Hoja de contratos

En el examen te darán otros nombres, pero esto es lo que debe coincidir **letra por letra**:

**Dominio:** `productosCafe = ['Café','Torta','Jugo','Galletas']`, `cantidadMaxima = 5`, `Pedido({required cliente, producto, cantidad})`.
`validarCliente`: vacío o solo espacios → `'Escribe el nombre del cliente'` · menos de 3 letras → `'El nombre debe tener al menos 3 letras'` · si no, `null`.
`validarCantidad`: `null` → `'Escribe la cantidad con número'` · fuera de 1–5 → `'La cantidad debe ser de 1 a 5'` · si no, `null`.

**Datos:** `abstract class PedidoRepository { guardar(Pedido); entregar(int); todos(); }` · `MemoriaPedidoRepository` con lista privada y `List.unmodifiable`.

**ViewModel:** `PedidosViewModel(PedidoRepository)`, `pedidos = []`, `String? error`, `guardando = false`, `get totalPiezas`, `cargar()`, `registrar(cliente, producto, cantidadTexto) → Future<bool>`, `entregar(int)`, `limpiarError()`.

**main:** `CafeUtezApp({required PedidoRepository repositorio})`, `ChangeNotifierProvider` arriba, `home: const PedidosPage()`.

**Pantallas:**

| Pantalla | Elemento | Contrato |
|---|---|---|
| PedidosPage | Barra de arriba | `'Cafetería UTEZ'` |
| | Encabezado | `'Pedidos: N · Piezas: P'` |
| | Sin pedidos | `'Sin pedidos'` |
| | Fila | título: producto · subtítulo: `'Ana · x3'` |
| | Entregar | `IconButton` con `Key('entregar_$i')` |
| | Botón flotante | `Key('nuevo')` → `limpiarError()` + `push` |
| NuevoPedidoPage | Barra de arriba | `'Nuevo pedido'` |
| | Campos | `Key('cliente')`, `Key('producto')` (Dropdown, empieza en el primero), `Key('cantidad')` |
| | Error | `Text` con el mensaje exacto |
| | Botón | `FilledButton 'Agregar'`, desactivado (`null`) si `guardando` |
| | Al agregar | si se guardó → `pop`; si no, se queda |

## 4.4 Si algo sale mal

| Lo que ves | Qué pasó | Cómo arreglarlo |
|---|---|---|
| `ProviderNotFoundException` al abrir el formulario | El gancho (provider) quedó dentro de `home` | Súbelo arriba de `MaterialApp` (paso 5) |
| La lista no se actualiza | Falta el último `notifyListeners()`, o usaste `read` en `build` | `watch` en `build`; avisa al terminar (paso 4) |
| El botón Agregar se queda gris | `guardando` nunca vuelve a `false` | Ponlo en `false` y avisa |
| *Tried to listen… outside of the widget tree* | Usaste `watch` dentro de un `onPressed` | Usa `read` en los botones |
| *Vertical viewport was given unbounded height* | La lista está en una `Column` sin `Expanded` | Envuélvela en `Expanded` (paso 6) |
| Al reabrir el formulario sale el error viejo | No llamas `limpiarError()` antes del `push` | Llámalo en el botón flotante |
| *setState() called during build* | Llamaste `limpiarError()` en `initState` | Llámalo en el botón, no al abrir la pantalla |
| *Target of URI doesn't exist: package:cafe_utez* | El proyecto no se llama `cafe_utez` | `name: cafe_utez` en `pubspec.yaml` |
| *use_build_context_synchronously* | Usaste `context` después de un `await` | `if (!mounted) return;` antes |
| "se esperaba 1 prueba y hay 2" | Quedó `test/widget_test.dart` | Bórralo |
| `pub add provider --offline` falla | No guardaste provider antes | Paso 0 (con internet) |
| *command not found: flutter* | Flutter no está instalado o la terminal no lo encuentra | Sección 1.2 |
| `No pubspec.yaml file found` | Estás en la carpeta equivocada | `pwd` para ver dónde estás; `cd cafe_utez` |

## 4.5 Experimentos para entenderlo de verdad

Rompe algo a propósito, mira qué pasa y regrésalo:

- **Gancho mal puesto:** mueve el `ChangeNotifierProvider` dentro de `home:` → presiona `R` → toca *Nuevo pedido* → `ProviderNotFoundException`.
- **¿Tu prueba detecta errores?** Comenta (pon `//` al inicio) la línea `await _repositorio.guardar(...)` del ViewModel → `flutter test` debe **fallar**.
- **Olvidar el último `notifyListeners()`** de `registrar`: el pedido se guarda, pero la lista no cambia y el botón queda gris.
- **`watch` en un botón:** cambia un `read` por `watch` → error *Tried to listen… from outside of the widget tree*.

## 4.6 Preguntas de repaso

Contéstalas en voz alta señalando el código:

1. ¿Quién es la fuente de verdad de los pedidos? → La libreta (repositorio). El ViewModel tiene una copia que vuelve a leer con `todos()`.
2. ¿Por qué `totalPiezas` es `get`? → Es derivado; si fuera un campo podría quedar desactualizado.
3. ¿Qué estado es efímero y cuál compartido? → Efímero: lo escrito en los campos y el producto (`setState`). Compartido: `pedidos`, `error`, `guardando` (`notifyListeners`).
4. ¿ChangeNotifier vs provider? → ChangeNotifier **avisa**; provider **entrega** el ViewModel a las pantallas y lo limpia al final.
5. ¿`watch` vs `read`? → `watch` en `build` (se queda pendiente); `read` en botones (lo pide una vez).
6. ¿Por qué el provider va arriba de `MaterialApp`? → Las pantallas abiertas con `push` quedan dentro de `MaterialApp`, no dentro de `home`.
7. ¿Por qué el ViewModel importa `foundation.dart`? → No dibuja; `ChangeNotifier` vive ahí.
8. ¿Por qué recibe `PedidoRepository` y no `MemoriaPedidoRepository`? → Para depender del contrato: libreta falsa en pruebas, internet en el futuro.
9. Si mañana los datos vienen de internet, ¿qué cambias? → Un archivo nuevo en `datos/` que cumpla el contrato + una línea en `main.dart`.
10. ¿Por qué tu prueba no necesita pantalla ni internet? → La lógica está en el ViewModel y la libreta es de memoria.
11. ¿Qué pasa si olvidas el último `notifyListeners()`? → Se guarda pero nadie se entera; el botón queda gris.
12. ¿Por qué `mounted` antes de `pop`? → La pantalla pudo cerrarse mientras se esperaba el `await`.
13. ¿Dónde vive la regla "mínimo 3 letras"? → Solo en `validarCliente` (dominio).
14. ¿Qué patrones de la clase usa la app? → Repository, Inyección de dependencias y Observer.

## 4.7 Plan de estudio y simulacro de 90 min

1. **Vuelta guiada (~2 h):** lee la Parte 2 y luego la Parte 3 con el código abierto. En cada línea pregúntate *¿por qué está aquí?*
2. **Vuelta con apoyo (~1.5 h):** en otra carpeta, haz los pasos 1 a 10 escribiendo tú el código y mirando solo la [hoja de contratos](#43-hoja-de-contratos). Si te atoras, mira el paso. Al final corre `autoevaluar.sh`.
3. **Simulacro (90 min, sin internet, sin mirar):**

| Etapa | Paso de esta guía | Minutos | Acumulado |
|---|---|---|---|
| 0 | Paso 1: crear proyecto + provider | 5 | 5 |
| 1 | Paso 2: dominio | 10 | 15 |
| 2 | Paso 3: datos | 8 | 23 |
| 3 | Paso 4: ViewModel | 17 | 40 |
| 4 | Pasos 5 y 6: main.dart + lista | 15 | 55 |
| 5 | Paso 7: formulario | 15 | 70 |
| 6 | Paso 8: tu prueba | 10 | 80 |
| 7 | Pasos 9 y 10: revisar + zip | 10 | 90 |

Si sacas 90/90 con tiempo de sobra, estás listo. Si pierdes puntos, `autoevaluar.sh` te dice en qué renglón: repite ese paso.

## 4.8 Checklist antes de entregar

- [ ] `name: cafe_utez` y `provider` en `pubspec.yaml`
- [ ] `dominio/` y `datos/` sin nada de Flutter
- [ ] ViewModel: `extends ChangeNotifier`, importa `foundation.dart`, recibe el contrato
- [ ] Reglas solo en el dominio · `totalPiezas` como `get`
- [ ] `ChangeNotifierProvider` arriba de `MaterialApp`
- [ ] `watch` en `build`, `read` en botones
- [ ] `push` para abrir, `pop` solo si se guardó · `dispose()` en el formulario
- [ ] Textos y `Key`s idénticos al contrato
- [ ] UNA prueba con Preparar / Actuar / Comprobar que revisa la libreta
- [ ] Script en "todo OK" · `flutter analyze lib` limpio · `flutter test` verde
- [ ] `flutter clean` + `zip -r MATRICULA_APELLIDO_cafe_utez.zip cafe_utez`

> Fuente: [Práctica guiada pre-examen — Unidad II (Notion)](https://spot-duke-7b6.notion.site/Pr-ctica-guiada-pre-examen-Unidad-II-Cafeter-a-UTEZ-411e73d41d938044972fd9a374ec97a8).
