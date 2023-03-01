# Diary Refactoring ReadME

- MVC를 기반으로 팀원과 만든 Diary앱을 개인적으로 MVVM-C로 Refactoring하였습니다.
- 텍스트 기능을 구현 할 때, 아이폰 `메모` 앱의 텍스트 입력 로직을 참고하였습니다.

## 목차
1. [팀 소개](#팀-소개)
2. [GroundRule](#ground-rule)
3. [Code Convention](#code-convention)
4. [타임라인](#타임라인)
5. [실행 화면](#실행-화면)
6. [폴더 구조](#폴더-구조)
7. [기술적 도전](#기술적-도전)
8. [트러블 슈팅 및 고민](#트러블-슈팅-및-고민)
9. [참고 링크](#참고-링크)


## 팀 소개
|[Kyo](https://github.com/KyoPak)|[Baem](https://github.com/Dylan-yoon)|
|:---:|:---:|
| <img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src= "https://user-images.githubusercontent.com/59204352/193524215-4f9636e8-1cdb-49f1-9a17-1e4fe8d76655.PNG" >|<img width="180px" img style="border: 2px solid lightgray; border-radius: 90px;-moz-border-radius: 90px;-khtml-border-radius: 90px;-webkit-border-radius: 90px;" src= https://i.imgur.com/jrW5RQj.png>|

## Ground Rule

[Ground Rule 바로가기](https://github.com/Dylan-yoon/ios-diary/wiki/GroundRule)

## Code Convention

[Code Convention 바로가기](https://github.com/Dylan-yoon/ios-diary/wiki/Code-Convention)

##  타임라인
### 👟 Step 1: Team

- ✅ Date Formatter의 지역 및 길이별 표현의 활용
- ✅ Text View의 활용
- ✅ Notification을 활용한 키보드 동작에 따른 View 제어
- ✅ Compositional Layout을 이용한 CollectionView 활용
- ✅ SwiftLint 적용

<details>
<summary> 
펼쳐보기
</summary>
    
1️⃣ MainViewController
- 앱 동작 시 가장 먼저 보여주는 View에 대한 `Controller`입니다.
- `MainViewController`에서 CollectionView의 DataSource로는 DiffableDataSource를 사용하였습니다.
    
2️⃣ AddViewController
- Right Navigation Bar Button을 클릭했을 때 보여지는 `AddDiaryView`에 대한 `Controller`입니다.
- 내부에서 `title`을 설정 언어에 맞는 날짜로 설정하였습니다.
    
3️⃣ DecodeManager
- 임시데이터인 Json 데이터에 대한 `Decoder`와 decode관련 메서드를 정의한 구조체가 정의된 파일입니다.
    
4️⃣ Diary
- 말 그대로 Diary에 대한 데이터이며, `Hashable`을 만족하기 위해 `uuid`를 추가하였습니다.

</details>

### 👟 Step 2: Team

- ✅ 코어데이터 모델 생성
- ✅ Swipe를 통한 삭제기능 구현
- ✅ Swipe를 통한 공유기능 구현
- ✅ ActivityController 구현
- ✅ NSMutableAttributeString 활용
- ✅ UICollectionLayoutListConfiguration 활용
- ✅ Text View Delegate의 활용

<details>
<summary> 
펼쳐보기
</summary>
    
1️⃣ CoreDataManager
- CoreDataManager에서 CRUD를 구현하였습니다.
    - Create(Save)
    - Read(Fetch)
    - Update
    - Delete   
- 위 메서드들을 정의하여 CoreDataManager의 싱글톤 객체에서 호출할 수 있도록 구현하였습니다.

2️⃣ AddViewController ➡️ EditViewController
- Add, Modify하는 기능의 Controller을 하나의 Controller로 통합하였습니다.

    
3️⃣ EditDiaryView
- Add, Modify 화면을 하나의 View로 통합하였습니다.


</details>

### 👟 Step 3: Team

- ✅ Open API의 활용
- ✅ Core Location의 활용
- ✅ 코어데이터 모델 및 DB 마이그레이션
- ✅ 코어데이터 모델 Relationship 사용
- ✅ NSMutableAttributeString 사용
- ✅ selectedTextRange 사용
- ✅ NSCache 사용
- ✅ DarkMode 적용

<details>
<summary> 
펼쳐보기
</summary>
    
1️⃣ CurrentDiary
- CoreData의 ManagedObject에 직접 접근하지 않기 위한 Type입니다.
- 해당 인스턴스를 생성하여 사용자가 입력한 Diary 정보들을 넣고 CoreData 내부에 Save하도록 하였습니다.

2️⃣ CurrentWeather

- CoreData의 ManagedObject에 직접 접근하지 않기 위한 Type입니다.
- 사용자 Device에 대한 위도 경도를 바탕으로 해당 인스턴스를 생성하여 Open API에서 가져온 날씨에 대한 data와 icon에 대한 data를 넣고 CoreData 내부에 Save하도록 하였습니다.
    
3️⃣ NetworkManager

- Server에 데이터를 요청하기 위한 fetchData()가 속해있는 class입니다.
- 해당 클래스는 여러개 만들 필요가 없다고 생각되어 싱글톤 패턴을 사용하였습니다.

4️⃣ NetworkRequest

- 위도, 경도를 바탕으로 날씨에 대한 data, 날씨 iconID에 대한 data를 받아올 수 있는 URL.
- 날씨 iconID을 서버에 보내서 해당 ID에 맞는 IconImage를 받아올 수 있는 URL.
- 위의 2개의 case에 맞는 URL을 얻기 위해 만든 별도의 enum 타입입니다.
    
5️⃣ WeatherAPIData  

- 서버에서 받아온 weather 데이터를 디코딩하기 위한 Type입니다.
    
</details>

### 👟 Refactoring MVVM-C: Personal
기간 : 2023/02/19 ~ 2023/03/01

- ✅ MVVM Architecture 사용
- ✅ Coordinator 패턴 사용
- ✅ Clean Architecture 사용
- ✅ SearchBar 구현
- ✅ Builder 패턴 사용하여 Alert 관리
- ✅ Unit Test


## 실행 화면

### ▶️ Step-1 실행화면

<details>
<summary> 
펼쳐보기
</summary>


|**실행화면**|**언어변경**|
|:---:|:---:|
|<img width = 600, src = "https://i.imgur.com/pItjW58.gif" >|<img width = 600, src = "https://i.imgur.com/ghHB03I.gif" >|

</details>

### ▶️ Step-2 실행화면

<details>
<summary> 
펼쳐보기
</summary>

|**미 입력**|**일기생성**|**Background 진입시 저장**|
|:---:|:---:|:---:|
|<img width = 600, src = https://i.imgur.com/JDS28lP.gif >|<img width = 600, src = https://i.imgur.com/U6RjgRR.gif>|<img width = 600, src = https://i.imgur.com/awPjF8d.gif>|
|**ActivityController구현**|**스와이프삭제**|**일기내에서 삭제**|
|<img width = 600, src = https://i.imgur.com/hgE4E9J.gif>|<img width = 600, src = https://i.imgur.com/eispxGL.gif>|<img width = 600, src = https://i.imgur.com/eVl3qBU.gif>|
    
</details>


 ### ▶️ Step-3 실행화면

<details>
<summary> 
펼쳐보기
</summary>

|**CLLocation의 사용**|**Cell찌그러짐 개선**|
|:---:|:---:|
|<img width = 600, src = https://i.imgur.com/eYq0jIx.gif>|<img width = 600, src = https://i.imgur.com/va3mB73.gif>|
|**AttributeString커서이동 보완**|**DarkMode**|
|<img width = 600, src = https://i.imgur.com/E9azBaH.gif>|<img width = 600, src = https://i.imgur.com/nvOEatF.gif>|
</details>
 
 
### ▶️ Personal - Refactoring 실행화면

|**사용**|**Search**|**Dark 모드**|
|:---:|:---:|:---:|
|<img width = 600, src = https://i.imgur.com/yr4RG51.gif>|<img width = 600, src = https://i.imgur.com/cDWOynB.gif>|<img width = 600, src = https://i.imgur.com/R1UhMw2.gif>|


## 폴더 구조
```
├── Diary
│   ├── Diary.xcdatamodeld
│   ├── MappingModelV2ToV3.xcmappingmodel
│   ├── Resource
│   └── Source
│       ├── AlertBuilder
│       │   ├── AlertBuilder.swift
│       │   ├── AlertDirector.swift
│       │   └── ConcreteAlertBuilder.swift
│       ├── Application
│       │   ├── AppDelegate.swift
│       │   └── SceneDelegate.swift
│       ├── Coordinator
│       │   ├── Coordinator.swift
│       │   ├── DetailCoordinator.swift
│       │   ├── ListCoordinator.swift
│       │   └── MainCoordinator.swift
│       ├── Data
│       │   └── Repository
│       │       ├── Cache
│       │       │   └── CacheService.swift
│       │       ├── CoreData
│       │       │   ├── CoreDataService.swift
│       │       │   ├── DiaryData+CoreDataClass.swift
│       │       │   ├── DiaryData+CoreDataProperties.swift
│       │       │   ├── WeatherData+CoreDataClass.swift
│       │       │   └── WeatherData+CoreDataProperties.swift
│       │       ├── DefaultCacheRepository.swift
│       │       ├── DefaultCoreDataRepository.swift
│       │       ├── DefaultNetworkRepository.swift
│       │       └── Network
│       │           ├── NetworkRequest.swift
│       │           ├── NetworkSevice.swift
│       │           └── WeatherAPIData.swift
│       ├── Domain
│       │   ├── Entity
│       │   │   ├── CurrentWeather.swift
│       │   │   ├── DecoderManager.swift
│       │   │   ├── DiaryReport.swift
│       │   │   └── WrapperData.swift
│       │   ├── RepositoryProtocol
│       │   │   ├── CacheRepository.swift
│       │   │   ├── CoreDataRepository.swift
│       │   │   └── NetworkRepository.swift
│       │   └── UseCase
│       │       ├── CheckCacheUseCase.swift
│       │       ├── DeleteDiaryReportUseCase.swift
│       │       ├── FetchDiaryReportsUseCase.swift
│       │       ├── FetchWeatherDataUseCase.swift
│       │       ├── LoadWeatherImageUseCase.swift
│       │       └── SaveDiaryReportUseCase.swift
│       ├── Presentation
│       │   ├── DetailScene
│       │   │   ├── View
│       │   │   │   ├── DetailViewController.swift
│       │   │   │   └── NavigationView.swift
│       │   │   └── ViewModel
│       │   │       └── DetailViewModel.swift
│       │   ├── Protocol
│       │   │   ├── ErrorPresentable.swift
│       │   │   └── ViewIdentifiable.swift
│       │   └── Scene
│       │       ├── View
│       │       │   ├── ListCell.swift
│       │       │   └── ListViewController.swift
│       │       └── ViewModel
│       │           ├── CellViewModel.swift
│       │           └── ListViewModel.swift
│       └── Util
│           ├── Constant
│           │   └── Error.swift
│           └── Extensions
│               ├── Formatter+Extension.swift
│               ├── NSMutableAttributedString+Extension.swift
│               ├── UIComponent+Extension.swift
│               └── UIViewController+Extension.swift
├── DiaryTests
│   ├── Presentation
│   ├── RepositoryTest
│   │   ├── CacheRepositoryTests.swift
│   │   ├── NetworkRepositoryTests.swift
│   │   └── Mocks
│   │       ├── MockCacheService.swift
│   │       └── MockNetworkService.swift
│   └── UseCaseTest
│       ├── DeleteDiaryReportUseCaseTest.swift
│       ├── FetchDiaryReportsUseCaseTest.swift
│       ├── SaveDiaryReportUseCaseTest.swift
│       └── Mocks
│           └── MockCoreDataRepository.swift
│       
├── Podfile
├── Podfile.lock
└── README.md
```

## 기술적 도전

### ⚙️ MVVM
<details>
<summary> 
펼쳐보기
</summary>
    
- 몇 차례 MVVM 설계 패턴을 사용해보고 느낀 장점은 ViewController와 ViewModel의 역할 분리가 확실히 된다는 점과
ViewModel이 담고 있는 비즈니스 로직에 대한 Testable한 코드 작성이었습니다.

    
</details>

### ⚙️ Clean Architecture
<details>
<summary> 
펼쳐보기
</summary>

- 클린아키텍처를 사용함으로서 기존 ViewModel이 담고 있던 비즈니스로직을 UseCase(Domain Layer)로 나누고 더 나아가 Repository(DataLayer)로 책임들을 나눔으로서 각 영역이 확실한 책임을 가질 수 있게 되었다고 생각합니다.
- 클린아키텍처를 경험해보며 느낀점은 아래와 같습니다.
    - 해당 프로젝트 같은 소규모 앱에도 많은 파일과 폴더 구분화 작업이 필요함을 느꼈으며 작은 규모의 앱보다는 큰 규모의 앱에서 더욱 효과적일 것이라고 생각이 들었습니다.
    - 확장성, 유지보수성 : UI적인 부분이 바뀐다면 view,viewModel / DB,Network관련 부분이 변경된다면 Repository 구체 타입까지만 변경하면 되기 때문에 변경에 있어서 강점이 있다고 생각이 들었습니다.
    - Testable한 코드 : 책임을 모두 분배함으로서 UnitTest를 시행할 때도 기존의 MVVM보다 세분화하여 Test를 수행할 수 있었던 것 같습니다.

</details>

### ⚙️ Coordinator Pattern 
<details>
<summary> 
펼쳐보기
</summary>

사용 이유
- `CoreDataRepository`의 객체를 UseCase마다 여러 번 생성하다보니 `persistentContainer`의 중복이 발생하여 정상 동작하지만 warning이 발생하였습니다.
    하나의 코어데이터 객체를 공유하려다보니 각 UseCase에서 `CoreDataRepository` 객체에 대한 접근제어를 낮추거나 해당 객체를 반환하여 다른 viewModel에 전달해줘야 하는 로직이 필요하였습니다.
    이런 로직은 매우 부자연스럽다고 생각이 들었고, `Coordinator`를 사용하여 해당되는 `Coordinator`에서 뷰의 이동시에 Repository 객체를 전달하여 viewModel에 주입해주면 좋다는 생각이 들었습니다.<br></br>

느낀 점
 - `Coordinator`를 사용해보니 뷰의 이동에 대한 로직이 굉장히 깔끔해졌다고 생각이들었습니다. 또한 `ViewController(View)`에서 화면이동 및 다음 화면의 `ViewModel`을 주입해줘야하는 책임이 없어지다보니 코드가 한결 간결해졌습니다.
    향후 앱의 규모가 커져서 하나의 View에서 이동해야 할 View가 많을 때 보다 효과적이고 좋은 확장성을 가질 수 있을 것이라고 생각이 들었습니다.
    
</details>

### ⚙️ Search Bar 

<details>
<summary> 
펼쳐보기
</summary>

사용 이유
- 데이터가 매우 많아질 경우 User가 작성한 일기를 찾기 힘들것이라 판단되어 사용하였습니다.
- SearchBar에서 text를 입력할 때마다 ListViewModel에서 입력된 text가 포함된 content만을 보여줄 수 있도록 필터링을 하여 `filterDiaryReports`라는 프로퍼티에 필터링된 데이터를 넣어주었습니다.
- 해당 데이터를 view에 보여줄 수 있도록 바인딩 된 메서드가 조건에 맞는 호출이 되도록 구현하였습니다.

```swift
private var filterDiaryReports: [DiaryReport] = [] {
    didSet {
        if filterDiaryReports.isEmpty {
            dataHandler?(diaryReports)
        } else {
            dataHandler?(filterDiaryReports)
        }
    }
}
```
    
</details>


### ⚙️ ModernCollectionView - CompositionalLayout

<details>
<summary> 
펼쳐보기
</summary>
    
- 확장성을 위해 CollectionView를 사용하여 TableView를 구성하고자 하였습니다.
추후에 요구사항이 Grid 형으로 변경되어도 빠른 대응이 가능하다고 생각하였습니다
- 하지만 개발을 모두 마친 후, 개발 속도를 고려한다면 비교적 쉬운 TableView를 사용하는 것이 빠른 프로젝트 진행에 도움이 될것이라는 생각도 들었습니다.
- 향후 Step2에서 해당 부분은 UICollectionViewList 혹은 UITableView로 변경될 예정입니다.

</details> 

### ⚙️ DiffableDataSource
<details>
<summary> 
펼쳐보기
</summary>
    
- 기존의 DataSource를 경험해보고 새롭게 Diffable Data Source를 사용해보고자 하였습니다.
- DiffableDataSource의 장점은 데이터 동기화, 데이터 추가, 업데이트, 삭제시 Animate적용이 가능하다는 점 입니다. 
- 또한 기존의 DataSource보다 코드량도 감소시킬수 있다는 점이 있습니다.
- 그리고 Section마다 다른 데이터들을 적용할 수도 있다는 점이 장점이라고 생각합니다.
- DiffableDataSource를 적용해보면서 코드의 길이가 길어지는 부분은 typealias를 활용하였습니다.
- 아직 Animation을 적용하는 부분이 많지 않아 기존 DataSource와 비교해서 장점에 대한 체감은 못하고 있습니다.
하지만 추후 Animation을 적용하는 부분이 많아진다면 Diffable DataSurce로 사용자 경험을 높힐 수 있다는 점은 큰 장점이라고 생각이 되어 도입해보았습니다.

    
</details> 

### ⚙️ DataFormatter, Locale의 사용
<details>
<summary> 
펼쳐보기
</summary>
    
- 새로운 Diary를 추가 할 때 지역에 맞는 날짜, 날짜 표기법을 수동적으로 선택해주는 것이 아닌 자동적으로 반환해주기 위해 DataFormatter를 추가해 주었습니다.
- 사용자의 기기 preferredLanguage에 따라 날짜의 표기방법이 자동으로 변경되도록 구현하였습니다.. (세계화, Internationalization)
- 사용자의 위치에 따라 날짜가 변할 수 있도록, `Locale`을 활용하여 Localization(지역화)를 해주었습니다.
    
``` swift
extension Formatter {
    static func changeCustomDate(_ date: Date) -> String {
        let locale = NSLocale.preferredLanguages.first
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: locale ?? Locale.current.identifier)
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        ...
        return formatter.string(from: date)
    }
}
```
    
</details> 

### ⚙️ Swipe 
<details>
<summary> 
펼쳐보기
</summary>
    
- 각 메인화면의 List의 Cell을 Swipe시 Share, Delete할 수 있는 기능이 필요하였습니다.
- Diary App에서 `UICollectionLayoutListConfiguration`를 사용하였기 때문에 `UISwipeActionsConfiguration`를 `configuration.trailingConfiguration`에 추가해주었습니다.
    
```swift
    var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.trailingSwipeActionsConfigurationProvider = .some({ indexPath in
            self.delegate?.makeSwipeActions(for: indexPath)
        })
```
- 그리고 ShareAction, DeleteAction을 추가 구현해주었습니다.
    
</details> 

### ⚙️ NSMutableAttributedString 사용
<details>
<summary> 
펼쳐보기
</summary>

- `NSMutableAttributedString`은 문자열의 특정 부분에 원하는 속성을 주고 싶을 때 사용하는 객체입니다. 특정 문자열만 다른 폰트, 다른 Color을 부여할 수 있습니다.
- 하나의 TextView에서 첫줄(Title)의 Text과 그 이외의 Text를 다른 Font를 적용하고자 하였습니다.
- 또한 AttributeString을 사용함에 따라 커서의 맨마지막으로 이동됨에 따라 `selectedTextRange`를 사용하여 올바른 커서의 위치로 이동시켜주었습니다.
    
</details> 

### ⚙️ CoreData Migration, Relationship
<details>
<summary> 
펼쳐보기
</summary>

- CoreData에 WeatherData 추가가 필요했기 때문에 Data Migration을 사용하였습니다. CoreData Migration은 Managed Object와 원본 간의 차이점을 자동으로 유추합니다. 이때 WeatherData를 추가만 했기때문에 별도의 MappingModel은 만들지 않았습니다.
- Migration을 진행을 한 후에, Weather Data와 기존의 Diary Data가 데이터의 성향이 다르기 때문에 하나의 Entity에 있는 것은 맞지 않다고 느껴졌습니다.
- 때문에, Entity들 간의 관계를 정의해 줄 수 있는, Entity들 간의 영향을 설명해줄 수 있는 Relationship을 추가해주었습니다.
- 추가를 한후에는 하나의 Entity에서 두 개의 Entity로 나눠졌기 때문에 별도의 MappingModel 또한 추가해 주었습니다.

|DiaryData|WeatherData|
|:---:|:---:|
|![](https://i.imgur.com/IgQnhfA.png)|![](https://i.imgur.com/oXfFzi1.png)|

    
</details> 

### ⚙️ Open API
<details>
<summary> 
펼쳐보기
</summary>

- Device의 위도 경도를 바탕으로 현재 날씨 및 날씨와 관련된 Icon을 받아오기 위해 Openweather API를 사용하였습니다.
- NetworkManager라는 클래스를 만들고 내부에서 API와 통신을 할 수 있는 메서드를 구현해주었습니다.

    
</details> 

### ⚙️ Core Location 
<details>
<summary> 
펼쳐보기
</summary>

- Core Location은 iOS 기본 Framework인 Core Service에 속해있는 Framework입니다.
- 기본적으로 iPhone Device의 위치를 얻어올 수 있는 Framework입니다.
- Core Location을 사용하기 위해서는 `CLLocationManger`라는 인스턴스를 반드시 사용해야합니다.
- 또한, Info.plist에서 위치 권한을 허용할 수 있는 정보 제공 Alert을 띄워줘야합니다.
- 해당 프로젝트에서는 일기를 입력할 때, 위치를 불러와서 위치에 대한 날씨 정보(날씨 아이콘)을 Navigation Bar에 보여줘야하고, Main 화면에서 저장한 날씨 정보에 대한 날씨 아이콘을 보여줘야했기 때문에 위도, 경도 저장을 위해 사용을 하였습니다.
    
```swift
if let coordinate = locations.last?.coordinate {
    let url = NetworkRequest.fetchData(lat: String(coordinate.latitude), 
    lon: String(coordinate.longitude)).generateURL()
...
```
    
- 위 코드처럼 coordinate에서 위도, 경도를 받아 올 수 있습니다.

</details>

## 트러블 슈팅 및 고민

### 🔥 Keyboard 사용에 따른 AutoLayout Constraint 변경에 대한 고민

<details>
<summary> 
펼쳐보기
</summary>

**문제 👀**
- 저희는 키보드 사용에 따라 `TextView`의 제약조건을 변경하여 `TextView`가 키보드를 제외하고 보여지도록 했습니다. 하지만 `TextView`의 `Bottom`제약을 변경해주는 방식으로 구현했습니다. 
<img width= 400px, src ="https://i.imgur.com/J4xs8tc.png">
위의 사진처럼 Constarint의 충돌이 일어났습니다.
**해결 🔥**
- `func setupConstraints()` 내부에서 초기 Constraint를 잡아 줄 때, TextView의 Bottom Constraint까지 잡아주고, 키보드 나타남에 따라 다시 제약을 추가적으로 잡아주기 때문에 발생했습니다.
- 따라서 기존 Constraint을 `false`로 변경하고 새로운 제약을 `true` 해야 충돌나지 않기 때문에 주의해서 Constraint를 잡아주어야 합니다.

</details>


### 🔥 UIComponent Object 생성시 중복코드 감소에 대한 고민

<details>
<summary> 
펼쳐보기
</summary>

**문제 👀**
- UIComponent를 View에서 생성할때 클로저를 이용하여 생성하였었습니다.
여러개의 Label, StackView가 필요한 상황에서 코드의 중복성이 느껴졌고 비효율적이라고 생각이 들었습니다. 
    
**해결 🔥**
- 2개 이상 사용되는 UIComponent들에 대해서 Extension으로 저희가 원하는 convenience initializer을 생성해주었습니다.
- 이렇게 구현의 결과 1개의 `UIComponent`를 생성할때, 기존보다 코드량이 1/5 줄로 감소하였습니다.

```swift
// Befor 
private lazy var bottomStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [dateLabel, previewLabel])
    stackView.spacing = 5
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fill
    return stackView
}()

// After
private lazy var bottomStackView = UIStackView(subview: [dateLabel, previewLabel],
                                            spacing: 5,
                                            axis: .horizontal,
                                            alignment: .firstBaseline,
                                            distribution: .fill)
```
    
</details>


### 🔥 Add, Modify 기능을 하나의 View, 하나의 Controller로 구현

<details>
<summary> 
펼쳐보기
</summary>
    
- Diary를 ADD하고, Modify하는 Controller의 역할과 View가 매우 유사하다고 생각을 했습니다.
- `MainViewController`에서 Modify를 할 때는 `indexPath`를 통해 데이터를 전달하고, + 버튼을 눌러 추가할때는 `nil`을 전달하여 Controller가 Add기능, Modify기능을 분기처리 할 수 있도록 구현하였습니다.
- 두 가지의 기능을 하나로 하였을 때의 장점은 로직은 추가되지만 전체적인 코드량 감소, 관리할 Class가 적어진다는 점이라고 생각이 듭니다.
- 하지만, 두 개의 컨트롤러를 사용하면 로직이 간결해진다는 점, 명확하다는 점에서 이점이 있다고 생각이 들었습니다. 
    
</details>


### 🔥 UISwipeActionsConfiguration 추가 

<details>
<summary> 
펼쳐보기
</summary>
    
- 리스트를 구현하기위해 `UICollectionLayoutListConfiguration`을 사용하였습니다.
- `CollectionView`의 `Configuration` 구성은 View의 역할이라고 생각이 되어 View 내부에 `CollectionView Configure`을 하는 메서드를 구현하였습니다.
- 후에, Swipe를 구현해야했을 때 View에서 구현한 Configure하는 메서드에서 SwipeActione들을 추가해주어야 했고, Swipe 기능을 만들기 위해서는 Controller의 Snapshot에 대한 접근, Delete Swipe 기능을 위한 CoreData에 대한 접근을 필요로 하였습니다.
- `ViewController`에서 `CollectionView` 혹은, `Configure`을 View 생성시점에 주입하는 방법도 좋겟다고 생각했지만, `Controller`의 역할에서 벗어난 기능을 수행한다고 판단하여 Delegate 패턴을 사용하여 `SwipeConfiguration`을 전달하였습니다.
    
</details>

### 🔥 NSMutableAttributedString 사용에 따른 TextView내부 텍스트 커서 이동

<details>
<summary> 
펼쳐보기
</summary>
    
- 처음에는 `textField`와 `textView`에 만들었습니다. 각각에 해당하는 폰트를 사용했습니다.
    - textField : title3
    - textView : body 
- 그렇기 때문에 Field, View 간의 간섭이 없기 때문에 폰트에 대해서 신경을 많이 써주지 않았습니다.
- 많은 생각 후, 우리는 아이폰 `메모`앱을 참고하여 사용을 고려하여, 하나의 `TextView`로 보여주고자 했습니다.
- 그렇기에 `NSMutableAttributedString`을 사용하여 첫번째 Title 부분만을 다른 폰트로 적용하였습니다.

#### 문제 👀
```
func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool { ... }
    
func textViewDidChange(_ textView: UITextView) { ... } 
```
- 텍스트 입력시 즉각적으로 Font 변경을 위해 위의 두 메서드를 사용하였는데,
- `NSMutableAttributedString` 이 호출될 때마다 `텍스트 커서`가 텍스트의 마지막에 위치하게 되었습니다.
    
#### 해결방법 🔥

- AttributeString을 사용하면서 텍스트 입력시 매번 AttributeString이 호출 되기 때문에 텍스트 커서가 맨 마지막으로 움직이는 것을 확인했습니다.
- 그래서 텍스트의 변화가 감지되는 Delegate인 textViewDidChange를 이용했습니다.
- 텍스트가 감지되고 커서의 위치를 기억한 후 AttributeString을 호출합니다. 그다음 원래 커서로 돌아가도록 만들어 주었습니다.
- textRange(from: to:) 및 UITextPosition()을 사용하여 커서의 위치를 기억하도록 했습니다.

```
func textViewDidChange(_ textView: UITextView) {
        guard let range = textView.selectedTextRange else { return }
        guard let position = textView.position(from: range.start, offset: 0) else { return }
        ...
        AttributeString()
        ...
        textView.selectedTextRange = textView.textRange(from: position, to: position)
    }
```
    
- 위와같이 텍스트를 기억 후 selectedTextRange를 통해 커서를 이동시켜 해결했습니다.

    
</details>

### 🔥 prepareForReuse 사용 시 Super 호출

<details>
<summary> 
펼쳐보기
</summary>

- 셀 재사용시 초기화를 위해 prepareForReuse를 호출했습니다.
- 하지만 아래의 사진과 같이 super를 호출하지 않고 사용하다보니 셀의 모양이 변형되는 현상이 발생했습니다.
    
|**super 호출**|**super 미호출**|
|:---:|:---:|
|![](https://i.imgur.com/qM8rSb6.png)|![](https://i.imgur.com/0CYIV3M.png)|   

- 그래서 override 할 때는 super 호출에 대해 한번더 생각해야 한다는 교훈을 얻었습니다....

</details>

### 🔥 Image load 속도 개선

<details>
<summary> 
펼쳐보기
</summary>
 
- `Data(contentsOf: url)`를 사용하여 이미지 데이터를 가져왔었습니다.
- 하지만 매우 느리게 아이콘이 업로드가 되었고, `Data(contentsOf: url)` 메서드를 알아본 결과 해당 메서드는 내부적으로 동기로 동작하기 때문에, 동작이 매우 느리다는 것을 알게되었습니다. 
- 또한 해당 메서드는 URLSession과 달리 작업에 대한 진단을 수행할 수 없었습니다. 
- URLSession에서는 오류가 네트워크 오류인지, HTTP 오류인지, contents 오류 인지 등을 판할 수 있는 반면 Data(contentsOf:)에서는 이를 확인할 수 없었습니다. 
- 따라서 이미지들을 dataTask를 활용하는 `dataTask`를 활용한 `fetchData()` 메서드를 사용하여 속도를 개선할 수 있었습니다.
    
</details>

### 🔥 Large Title 잔상 

<details>
<summary> 
펼쳐보기
</summary>
    
<img width = 400, src = "https://i.imgur.com/kwcgtJE.png" > 

- 위 사진처럼 전화면의 LargeTitle의 잔상이 다음 View 이동시 보이는 문제가 있었습니다.
- 실기기 테스트에서도 동일한 문제가 발생하였습니다.<br></br>
- 이동한 화면에서 LargeTitle을 사용을 희망하지 않아 `prefersLargeTitles`를 `false`했던 것이 문제였습니다.
- 해당 프로퍼티를 false로 하는 순간 `largeTitleDiaplayMode`는 동작하지 않게 되면서 그 전 화면의 잔상이 남고 false처리가 되는 것으로 보입니다.(확실하지는 않습니다..)
- 해당 프로퍼티를 true로 한 후, DisplayMode를 never(미사용)으로 변경 후 잔상 이슈를 해결할 수 있었습니다.
```swift
navigationController?.navigationBar.prefersLargeTitles = true
navigationItem.largeTitleDisplayMode = .never
```

</details>

### 🔥 Core Location은 비즈니스 로직에 포함일까?
<details>
<summary> 
펼쳐보기
</summary>

- 클린아키텍쳐를 구성하며 CoreLocation은 비즈니스로직일까?에 대한 의문이 들었습니다.
- 따라서 UseCase에 속해야하는지, ViewModel에 속해야하는지 고민이 되었습니다.
- 결론은 View에 속하게끔 구현하였습니다.
    - CoreLocation 같은 경우 유저가 거부하면 사용을 안할 수 있습니다.
    - 하지만 Business Logic은 회사의 정책이고, 필수적인 로직 및 기능 구현이라고 생각하였습니다.
    - 따라서 유저가 사용여부를 결정하는 `Core Location`의 경우 `Present Layer`에 속해야한다고 생각하였습니다.
    - 그리고 `Core Location`의 경우 권한 요청의 팝업이 뜨고 유저의 결정에 따라 기능 사용여부가 바뀌기 때문에
유저와의 상호작용이라고 생각하였고 View에 속해야한다고 생각이 들었습니다.

</details>

## 참고 링크

[공식문서]    
- Siwft_Language_Guide
    - [Swift Language Guide - Closure - Escaping Closures](https://docs.swift.org/swift-book/LanguageGuide/Closures.html)
- AppleDoucument
    - [UICollectionView](https://developer.apple.com/documentation/uikit/uicollectionview/)
    - [Adaptivity and Layout](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/adaptivity-and-layout)
    - [UITextView](https://developer.apple.com/documentation/uikit/uitextview)
    - [DateFormatter](https://developer.apple.com/documentation/foundation/dateformatter/)
    - [Core Data](https://developer.apple.com/documentation/coredata)
    - [Making Apps with Core Data](https://developer.apple.com/videos/play/wwdc2019/230/)
    - [UITextViewDelegate](https://developer.apple.com/documentation/uikit/uitextviewdelegate)
    - [UiSwipeactionsConfiguration](https://developer.apple.com/documentation/uikit/uiswipeactionsconfiguration)
    - [AppleDarkModeDoucument](https://developer.apple.com/documentation/uikit/appearance_customization/supporting_dark_mode_in_your_interface)
- HIG
    - [DarkModeHIG](https://developer.apple.com/design/human-interface-guidelines/foundations/dark-mode/)
    - [Color](https://developer.apple.com/design/human-interface-guidelines/foundations/color)
- API
    - [OpenWeatherAPI](https://openweathermap.org/current)
    - [OpenWeatherIcon](https://openweathermap.org/weather-conditions)
