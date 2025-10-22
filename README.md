# Exemplo do Bridgee iOS SDK

Um aplicativo iOS completo que demonstra como integrar e usar o **Bridgee SDK** para atribuição de usuários e rastreamento UTM. Este projeto mostra as melhores práticas para implementar o Bridgee SDK em suas aplicações iOS.

## 🚀 Principais Funcionalidades

- **Integração Completa do Bridgee SDK** - Mostra configuração e inicialização adequada do SDK
- **Integração com Firebase Analytics** - Demonstra o uso do Firebase como provedor de analytics
- **Coleta de Dados do Usuário** - Interface de formulário para coletar informações do usuário (nome, email, telefone)
- **Recuperação de Dados UTM** - Exibe parâmetros UTM (source, medium, campaign) de matches bem-sucedidos
- **Tratamento de Erros** - Manipulação adequada de callbacks para cenários de sucesso e erro
- **Swift Package Manager** - Usa SPM para gerenciamento de dependências

## 📋 Requisitos

- **Xcode 15.0+**
- **iOS 14.0+**
- **Swift 5.0+**
- **Projeto Firebase** (para provedor de analytics)

## 🛠️ Instruções de Configuração

### 1. Clonar o Repositório
```bash
git clone https://github.com/bridgee-ai/bridgee-ios-example.git
cd bridgee-ios-example
```

### 2. Configuração do Firebase
1. Crie um projeto Firebase no [Console do Firebase](https://console.firebase.google.com/)
2. Adicione um app iOS com bundle identifier: `com.example.BridgeeIOSExample`
3. Baixe o arquivo `GoogleService-Info.plist`
4. Substitua o arquivo placeholder em `BridgeeIOSExample/GoogleService-Info.plist`

### 3. Configuração do Bridgee SDK
Atualize a configuração em `BridgeeIOSExampleApp.swift`:

```swift
BridgeeSDK.shared.configure(
    provider: FirebaseAnalyticsProvider(),
    tenantId: "your-tenant-id",        // Fornecido pela Bridgee
    tenantKey: "your-tenant-key",      // Fornecido pela Bridgee
    dryRun: false                      // true para testes, false para produção
)
```

### 4. Executar o Projeto
1. Abra `BridgeeIOSExample.xcodeproj` no Xcode
2. Selecione um simulador ou dispositivo
3. Pressione `Cmd+R` para compilar e executar

## 📱 Como Funciona

### Fluxo do Usuário
1. **Inserir Dados do Usuário** - Preencha nome, email e/ou número de telefone
2. **Tocar em "Bridgee First Open"** - Aciona o método `firstOpen` do SDK
3. **Ver Resultados** - Veja os dados UTM (sucesso) ou mensagem de erro

### Resposta de Sucesso
Quando um match é encontrado, o app exibe:
```
✅ Success!
UTM data:

UTM Source: google
UTM Medium: cpc
UTM Campaign: summer_sale
```

### Resposta de Erro
Quando nenhum match é encontrado:
```
❌ Error
First Open without Match - No UTM Data
```

## 🏗️ Guia de Implementação

### 1. Adicionar Dependência do Bridgee SDK

Adicione ao seu `Package.swift` ou via Xcode:
```swift
dependencies: [
    .package(url: "https://github.com/bridgee-ai/bridgee-ios-sdk", from: "1.0.0")
]
```

### 2. Configurar o SDK

No seu arquivo `App.swift`:
```swift
import BridgeeSDK
import FirebaseCore
import FirebaseAnalytics

@main
struct SeuApp: App {
    init() {
        FirebaseApp.configure()
        
        BridgeeSDK.shared.configure(
            provider: FirebaseAnalyticsProvider(),
            tenantId: "your-tenant-id",
            tenantKey: "your-tenant-key",
            dryRun: false
        )
    }
}
```

### 3. Criar Provedor de Analytics

Implemente o protocolo `AnalyticsProvider`:
```swift
class FirebaseAnalyticsProvider: AnalyticsProvider {
    func setUserProperty(name: String, value: String?) {
        Analytics.setUserProperty(value, forName: name)
    }
    
    func logEvent(name: String, parameters: [String: Any]?) {
        Analytics.logEvent(name, parameters: parameters)
    }
}
```

### 4. Usar o SDK

Chame o método `firstOpen` com dados do usuário:
```swift
import BridgeeSDK

func sendFirstOpenEvent() {
    var matchBundle = MatchBundle()
    matchBundle.set(name: "João Silva")
    matchBundle.set(email: "joao@exemplo.com")
    matchBundle.set(phone: "+5511999999999")
    
    BridgeeSDK.shared.firstOpen(with: matchBundle) { utmData in
        DispatchQueue.main.async {
            if let utmData = utmData {
                // Sucesso - manipular dados UTM
                print("UTM Source: \(utmData.utm_source ?? "N/A")")
                print("UTM Medium: \(utmData.utm_medium ?? "N/A")")
                print("UTM Campaign: \(utmData.utm_campaign ?? "N/A")")
            } else {
                // Erro - nenhum match encontrado
                print("Nenhum dado UTM disponível")
            }
        }
    }
}
```

## 📁 Estrutura do Projeto

```
BridgeeIOSExample/
├── BridgeeIOSExampleApp.swift      # Configuração do app e setup do SDK
├── ContentView.swift               # UI principal com formulário e integração do SDK
├── GoogleService-Info.plist        # Configuração do Firebase (placeholder)
└── ...
```

## 🔧 Componentes Principais

### Configuração do BridgeeSDK
- **Provider**: Provedor de analytics (Firebase neste exemplo)
- **TenantId**: Seu identificador único de tenant da Bridgee
- **TenantKey**: Sua chave de autenticação da Bridgee
- **DryRun**: Defina como `true` para testes, `false` para produção

### MatchBundle
Usado para passar dados do usuário para o SDK:
- `set(name: String)` - Nome do usuário
- `set(email: String)` - Email do usuário
- `set(phone: String)` - Telefone do usuário

### Resposta UTMData
Contém informações de atribuição:
- `utm_source` - Fonte de tráfego (ex: "google", "facebook")
- `utm_medium` - Meio de marketing (ex: "cpc", "email")
- `utm_campaign` - Nome da campanha (ex: "promocao_verao")

## 🔒 Notas de Segurança

- Nunca faça commit de arquivos reais `GoogleService-Info.plist` no controle de versão
- Mantenha suas credenciais de tenant da Bridgee seguras
- Use variáveis de ambiente ou configuração segura para apps de produção

## 📚 Recursos Adicionais

- [Documentação do Bridgee SDK](https://github.com/bridgee-ai/bridgee-ios-sdk)
- [Guia de Setup do Firebase iOS](https://firebase.google.com/docs/ios/setup)
- [Guia do Swift Package Manager](https://swift.org/package-manager/)

## 🤝 Contribuindo

1. Faça um fork do repositório
2. Crie uma branch para sua feature
3. Faça suas alterações
4. Envie um pull request

## 📄 Licença

Este projeto de exemplo está disponível sob a Licença MIT.
