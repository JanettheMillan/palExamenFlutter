# Pre-examen Unidad II — Cafetería UTEZ (Flutter · MVVM · provider)

Repo de estudio para el examen práctico de la Unidad II.

| Rama | Qué contiene |
|------|--------------|
| `main` | Mi solución completa (`cafe_utez/`) + el kit del profe (`kit/`) + esta guía |
| `profesor` | El repo original del profe, tal cual: [cristiancampos-docente/PRE-EXAMEN-UNIDAD-II](https://github.com/cristiancampos-docente/PRE-EXAMEN-UNIDAD-II) |

```
PRE-EXAMEN-UNIDAD-II/
├── README.md                ← esta guía
├── kit/                     ← del profe (no se modifica)
│   ├── verificar_practica.sh    revisa capas y cableado (5 pts)
│   ├── autoevaluacion_test.dart batería R1–R4 (75 pts)
│   └── autoevaluar.sh           suma todo como en el examen (90 pts)
└── cafe_utez/               ← la app
    ├── pubspec.yaml         name: cafe_utez + provider
    ├── lib/
    │   ├── dominio/pedido.dart
    │   ├── datos/pedido_repository.dart
    │   ├── datos/memoria_pedido_repository.dart
    │   ├── presentacion/pedidos_view_model.dart
    │   ├── presentacion/pedidos_page.dart
    │   ├── presentacion/nuevo_pedido_page.dart
    │   └── main.dart
    └── test/pedidos_view_model_test.dart   ← la ÚNICA prueba propia
```

---

## 1. Primera vez: dejarlo corriendo

El repo ya trae las carpetas de plataforma (`web/`, `macos/`, `android/`, `ios/`), así que basta con:

```bash
cd cafe_utez
flutter pub get
flutter run -d chrome        # o: flutter run -d macos
```

Para el examen (sin internet), deja provider en la caché **una sola vez, con internet**:

```bash
dart pub cache add provider --version 6.1.5+1
dart pub cache add nested --version 1.0.0
```

> Si alguna vez falta una plataforma ("This application is not configured to build on the web"), regénérala sin pisar `lib/`:
> `flutter create --org mx.edu.utez --project-name cafe_utez --platforms=web,macos .` y luego `rm -f test/widget_test.dart README.md` (el script exige UNA sola prueba).

Verificar como lo hará el docente:

```bash
flutter test                              # tu prueba
flutter analyze lib                       # debe decir: No issues found!
cd ..
bash kit/verificar_practica.sh cafe_utez  # script de capas: todo OK
bash kit/autoevaluar.sh cafe_utez         # 90 / 90
```

---

## 2. Cómo funciona (de abajo hacia arriba)

```
 PRESENTACIÓN                                    DOMINIO           DATOS
 PedidosPage ─┐  watch (mostrar)                 Pedido            PedidoRepository (abstracto)
 NuevoPedido ─┤  read  (actuar)                  validarCliente           ▲ implements
              ▼                                  validarCantidad   MemoriaPedidoRepository
 PedidosViewModel (ChangeNotifier) ──usa reglas──►      ──usa SOLO el contrato──►
 main.dart: crea MemoriaPedidoRepository y cuelga el ViewModel con ChangeNotifierProvider
```

### Dominio — `lib/dominio/pedido.dart` (Dart puro, R1 = 15 pts)
- `Pedido` es la entidad: `const`, campos `final`.
- `productosCafe` y `cantidadMaxima` son **constantes**, no estado.
- `validarCliente(String)` y `validarCantidad(int?)` devuelven **el mensaje de error o `null`**. Así la vista muestra el texto tal cual.
- `trim()` antes de medir (`' Al '` son 2 letras). `validarCantidad` recibe `int?` porque convertir texto→número es trabajo del ViewModel.

### Datos — `lib/datos/` (R2 = 10 pts)
- `PedidoRepository` es el **contrato** (`abstract class`): `guardar`, `entregar`, `todos`. Todo `Future` aunque sea memoria, para poder cambiarlo por una API sin tocar nada más.
- `MemoriaPedidoRepository implements PedidoRepository`: lista privada `_pedidos`; `todos()` devuelve `List.unmodifiable` para que nadie la altere por fuera.
- El repositorio es la **fuente de verdad**.

### ViewModel — `lib/presentacion/pedidos_view_model.dart` (R3 = 25 pts, el más importante)
- `extends ChangeNotifier`, importa **`foundation.dart`** (no `material`, no `provider`).
- Recibe el **contrato** por constructor (inyección de dependencias) → en pruebas le pasas un repo falso.
- Estado compartido: `pedidos`, `error`, `guardando`. Estado derivado: `get totalPiezas` (getter, nunca campo).
- `registrar(cliente, producto, cantidadTexto)`:
  1. `int.tryParse(texto.trim())` → `null` si no es número.
  2. `validarCliente(...) ?? validarCantidad(...)` → la primera regla que falle gana.
  3. Si falla: `error = motivo`, `notifyListeners()`, `return false` (no toca el repo).
  4. Si pasa: `guardando = true; error = null; notify` → guarda → **relee `todos()`** → `guardando = false; notify` → `return true`.
- `cargar()`, `entregar(i)`, `limpiarError()`: cambian estado y **siempre** avisan.

### main.dart (parte de R4)
- Único archivo que conoce `MemoriaPedidoRepository`.
- `CafeUtezApp` recibe `repositorio` por constructor → las pruebas del docente arrancan tu app con un repo espía.
- `ChangeNotifierProvider` va **ARRIBA de `MaterialApp`**. Si lo pones en `home`, la pantalla abierta con `push` no lo ve → `ProviderNotFoundException`.
- `PedidosViewModel(repositorio)..cargar()` → la cascada entrega el ViewModel (no el Future).

### Vistas (R4 = 25 pts)
- **`PedidosPage`** (Stateless): `context.watch` en `build` para mostrar; `context.read` en `onPressed` para actuar. `Expanded` alrededor del `ListView`. FAB `Key('nuevo')` → `limpiarError()` y `Navigator.push`. Botón por fila `Key('entregar_$i')`.
- **`NuevoPedidoPage`** (Stateful **solo** por estado efímero: controladores + producto del Dropdown con `setState`). `dispose()` libera controladores. Si `registrar` da `true` y `mounted` → `Navigator.pop`. Botón desactivado con `guardando ? null : _agregar`. Keys: `cliente`, `producto`, `cantidad`.

### Tu prueba — `test/pedidos_view_model_test.dart` (R5 = 10 pts + R6)
Preparar / Actuar / Comprobar. La línea clave es `repositorio.todos()`: demuestra que el ViewModel sí delegó en la capa de datos, no solo cambió su copia.

### Los 4 tipos de estado
| Tipo | Dónde | Ejemplo |
|------|-------|---------|
| Efímero | `State` + `setState` | texto de los campos, producto elegido |
| Compartido | ViewModel + `notifyListeners` | `pedidos`, `error`, `guardando` |
| Derivado | getter del ViewModel | `totalPiezas` |
| Persistido | repositorio | `_pedidos` |

---

## 3. Plan de estudio (3 vueltas)

1. **Guiada (~2 h):** lee cada archivo de `cafe_utez/lib` en este orden: dominio → datos → ViewModel → main → pedidos_page → nuevo_pedido_page → test. Por cada línea pregúntate *por qué está ahí* (la sección 2 lo explica).
2. **Con apoyo (~1.5 h):** en otra carpeta (`flutter create --empty --offline --org mx.edu.utez cafe_utez`) reescribe todo usando solo la **hoja de contratos** (abajo). Si te atoras, mira el archivo de `main`. Corre `autoevaluar.sh`.
3. **Simulacro (90 min, sin internet, sin mirar):**

| Etapa | Qué | Min | Acum. |
|---|---|---|---|
| 0 | Crear proyecto + provider offline | 5 | 5 |
| 1 | Dominio | 10 | 15 |
| 2 | Datos | 8 | 23 |
| 3 | ViewModel | 17 | 40 |
| 4 | main.dart + lista | 15 | 55 |
| 5 | Formulario + navegación | 15 | 70 |
| 6 | Tu prueba | 10 | 80 |
| 7 | Verificar + `flutter clean` + zip | 10 | 90 |

Si sacas 90/90 con tiempo de sobra, estás listo. Si pierdes puntos, `autoevaluar.sh` te dice en qué renglón: repite ese paso.

### Experimentos para entenderlo de verdad
- **Provider mal puesto:** mueve el `ChangeNotifierProvider` dentro de `home:` → hot restart → toca *Nuevo pedido* → `ProviderNotFoundException`. Regrésalo.
- **¿Tu prueba detecta errores?** Comenta `await _repositorio.guardar(...)` en el ViewModel → `flutter test` debe fallar.
- **Olvidar el último `notifyListeners()`** de `registrar`: el pedido se guarda pero la lista no se redibuja y el botón queda gris.
- **`watch` en un `onPressed`:** cambia un `read` por `watch` → error *Tried to listen… from outside of the widget tree*.

---

## 4. Hoja de contratos (lo que el examen te da con otros nombres)

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

## 5. Errores frecuentes

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
| `pub add provider --offline` falla | provider/nested no están en caché | `dart pub cache add` con internet |

---

## 6. Preguntas de repaso (contéstalas en voz alta, señalando el código)

1. ¿Quién es la fuente de verdad de los pedidos? → El repositorio; el ViewModel tiene una copia que relee con `todos()`.
2. ¿Por qué `totalPiezas` es getter? → Es derivado; un campo podría desfasarse.
3. ¿Qué estado es efímero y cuál compartido? → Efímero: controladores y producto (setState). Compartido: pedidos, error, guardando (notifyListeners).
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

> Fuente: [Práctica guiada pre-examen — Unidad II (Notion)](https://spot-duke-7b6.notion.site/Pr-ctica-guiada-pre-examen-Unidad-II-Cafeter-a-UTEZ-411e73d41d938044972fd9a374ec97a8) y el kit del profe.
