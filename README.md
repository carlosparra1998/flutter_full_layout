# Full Layout - Flutter Project Generator 🚀🚀🚀

CLI to generate a complete Flutter project with CLEAN ARCHITECTURE.

It will allow the developer to create a base project with CLEAN ARCHITECTURE. In this architecture, we use services (Cubits) for each use case. These services will communicate with repositories (for each use case), and these repositories will communicate with the DIO client (HTTP).

- In this layout, BLoC and Cubit are used for state management. 
- DIO is used for communication with the REST API. 
- l10n is used for translations.
- Real use case in full operation (Auth - login)
- Basic responsive design management
- Route management with GET
- Defined styles (text styles and colours)
- Complete initialiser in Splash Screen
- Predefined tests (unit, integration and widgets) [92% coverage].
- A homemade HTTP client (using DIO) that provides directly constructed objects/lists, without the need for processing (just indicate the fromJson of a specific class to target in the client).

---

# Deep Observer

Library that allows a simple and efficient management of the application reactivity in Flutter.

Using `Deep Observable` you will be able to:

- Manage the reactivity of your application in a simple way.
- **Implicit management**, which allows you to manage reactivity from the variables themselves, without the need to include unnecessary Wraps in your code.
- **Efficiency mode** (Experimental), where the minimum renderings necessary to control reactivity will be performed, avoiding recurrent and unnecessary updates.
 
## Usage

Let's take a look at the detailed steps for the proper use of Deep Observer.

---

### Step 1. Observers Creation.

The first thing will be to create a class that you consider as `provider`, however, it does not have to have any extension with `ChangeNotifier`.

Once created, we can declare variables of type `DeepObservable`, these will contain the necessary properties for the reactivity.

We must indicate the type of data to handle, and the value it will have initially.

```dart
class HomeController{
  HomeController();

  DeepObservable<int> observableInt = DeepObservable(0);

  DeepObservable<bool?> observableBool = DeepObservable(null);

  DeepObservable<List<String>> observableList = DeepObservable(<String>[]);
}
```
---

### Step 2. Dependency Injection

To use your `provider` classes with `DeepObservable` variables properly, dependency injection must be performed first. This can be done in two different ways.

#### Method 1. Global injection

To perform a global dependency injection, ideally wrap `MaterialApp` with `GlobalInjector`, indicating in *registrations* the `provider` classes to be used. They will be available from any point of the application.


```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalInjector(
      registrations: [
        () => MyCounterProvider(),
        () => LoginProvider(),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const HomeView(),
      ),
    );
  }
}
```

#### Method 2. Local injection

To perform a local dependency injection, simply wrap any Widget with `LocalInjector`, indicating in *registration* the `provider` class to use. It will be only for child widgets of `LocalInjector`.

```dart
class _MyRowCounterState extends State<MyRowCounter> {
  @override
  Widget build(BuildContext context) {
    return LocalInjector(
      registration: () => MyCounterProvider(),
      builder: (BuildContext context, MyCounterProvider provider) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Counter ${provider.counter.value}:',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

### Step 3. Status management

At this point we will detail how to manage the reactivity with all the above established. For this we can use two methods.

#### Method 1. Implicit management (Deep gesture) **{NEW}**

The first thing we must do is to obtain the instance of our `provider` class.

We can do it with the `context.deepGet<MyCounterProvider>()` method (Only if you are using `GlobalInjector`).

In case we have performed a local dependency injection, we can get the `builder` instance from `LocalInjector`. 

For implicit management, it is enough to obtain the desired value of the `DeepObservable` by `observable.reactiveValue(context)`.

With this, the `context` passed by parameter will automatically subscribe to the changes of the `DeepObservable`. In case of any change, or update, only the Widgets that are inside the tree generated by that `context` will be rendered.

```dart

class _MyRowCounterState extends State<MyRowCounter> {
  @override
  Widget build(BuildContext context) {
    MyCounterProvider provider = context.deepGet<MyCounterProvider>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Counter ${widget.identifier + 1}:',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
              ),
              Text(
                '${widget.observable.reactiveValue(context)}', //DEEP GESTURE
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              MyIconButton(
                Icons.add,
                onTap: () {
                  provider.incrementCounter(widget.identifier);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

```

#### Method 2. Explicit management (Classic management) 

As in the implicit management, the first thing we must do is to obtain the instance of our `provider` class.

We can do it with the `context.deepGet<MyCounterProvider>()` method (Only if you are using `GlobalInjector`).

In case we have performed a local dependency injection, we can get the `builder` instance from `LocalInjector`. But the `DeepUpdatable` widget must necessarily be inside the `LocalInjector` tree in this case.

For explicit management, we must wrap the widgets with `DeepUpdatable`. In *registrations* we can indicate any number of `provider` classes. The builder will contain (N + 1) parameters, being N the number of providers indicated in *registrations*. The first parameter will be a `context`.

The `context` generated by `DeepUpdatable` will automatically subscribe to changes in the `DeepObservable`. In case of any change, or update, only the Widgets that are inside the tree generated by that `context` will be rendered.

```dart
class _MyRowCounterState extends State<MyRowCounter> {
  @override
  Widget build(BuildContext context) {
    MyCounterProvider provider = context.deepGet<MyCounterProvider>();

    return DeepUpdatable(  //EXPLICIT GESTURE
      registrations: [provider.counter],
      builder:
          (BuildContext context, DeepObservable<int> counter) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Counter ${widget.identifier + 1}:',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      '${widget.observable.value}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    MyIconButton(
                      Icons.add,
                      onTap: () {
                        provider.incrementCounter(widget.identifier);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }
}
```

---

## ANNEX 1. Efficiency mode (Experimental)

An algorithm to improve the rendering efficiency of the listening `context` has been added to the library.

To activate it, we must add an additional parameter called `efficiencyMode`, which must be set to `true`.

```dart
class HomeController{
  HomeController();

  DeepObservable<int> observableInt = DeepObservable(0, efficiencyMode: true);

  DeepObservable<bool?> observableBool = DeepObservable(null, efficiencyMode: true);

  DeepObservable<List<String>> observableList = DeepObservable(<String>[], efficiencyMode: true);
}
```

In case of updating any `DeepObservable` with these properties, what will be done internally will be to take the `context` that are listening, and update only the necessary ones to properly update the user interface, avoiding unnecessary rendering.