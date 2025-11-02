# Calculadora de IMC - Flutter

A **Calculadora de IMC (Índice de Massa Corporal)** é um aplicativo desenvolvido em **Flutter**, projetado para calcular de forma simples e intuitiva o IMC de uma pessoa com base em seu peso e altura. O app apresenta uma interface moderna, interativa e responsiva, ideal tanto para demonstração técnica quanto para uso prático.

---

## Funcionalidade

O usuário informa o **peso (kg)** e a **altura (cm)**, e ao clicar em **"Calcule seu IMC"**, o aplicativo:

1. Seleção de Gênero
- Interface intuitiva para escolha entre Homem e Mulher
- Feedback visual com destaque na seleção
- Ícones representativos e animações suaves

2. Realiza o cálculo do IMC:  
   `IMC = peso (kg) / (altura (m)²)`
3. Exibe o resultado em um **semicírculo colorido** (feito com o pacote `percent_indicator`), indicando visualmente o nível de IMC.
4. Apresenta também uma **tabela de referência** completa para comparação:

    | IMC | Classificação | Cor |
    | :------ | :---------: | ------: |
    | `< 18.5` | Abaixo do peso | 🔵 |
    | `18.5 – 24.9` | Peso normal | 🟢 |
    | `25 – 29.9` | Sobrepeso | 🟠 |
    | `30 – 34.9` | Obesidade Classe I | 🔴 |
    | `35 – 39.9` | Obesidade Classe II | 🔴 |
    | `≥ 40` | Obesidade Classe III | 🔴 |

---

## Instalação

### Pré-requisitos

- Flutter SDK 3.0 ou superior
- Dart 3.0 ou superior
- Dispositivo ou emulador Android/iOS

### Passos para Instalação

1. Clone o repositório

    ```bash
    git clone https://github.com/seu-usuario/imc-calculator.git
    cd imc-calculator
    ```

2. Instale as dependências

    ```bash
    flutter pub get
    ```

3. Execute o aplicativo

    ```bash
    flutter run
    ```

### Build para Produção

    # Android
    flutter build apk --release
    
    # iOS
    flutter build ios --release

    # Web
    flutter build web --release



### Como Usar

1. Selecione o gênero "Homem" ou "Mulher"
2. Informe seu peso em quilogramas **(ex: 70.5)**
3. Informe sua altura em centímetros **(ex: 175)**
4. Pressione o botão **Calcule seu IMC** para ver o resultado
5. Analise o resultado e a classificação
6. Pressione o botão **Calcular Novamente** para novo cálculo

## Autora

Ana Quézia de Oliveira Souza
