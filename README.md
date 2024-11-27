# Crypto Tracker iOS App

![Crypto Tracker App](https://github.com/user-attachments/files/17935078/Purple.Pink.Gradient.Mobile.Application.Presentation.pdf)

Bu proje, kullanıcıların kripto para piyasasında anlık değişimleri takip etmelerine, favori kripto paralarını seçip izlemelerine ve her birinin detaylı grafiklerini görüntülemelerine olanak tanır. Uygulama MVVM (Model-View-ViewModel) Clean Architecture kullanarak geliştirilmiştir. Arayüz Swift Snapkit ile oluşturulmuştur.

## İçindekiler
- [Özellikler](#özellikler)
- [Sayfa Detayları](#sayfa-detayları)
- [Proje Yapısı](#proje-yapısı)
- [Kullanılan Kütüphaneler](#kullanılan-kütüphaneler)
- [Kurulum](#kurulum)

---

## Özellikler


- **Kripto Para Takibi:** Kullanıcılar, anlık olarak güncellenen kripto para verilerini görür ve bu verilere bağlı grafikler izler.
- **Favori Kripto Para Ekleme:** Kullanıcılar, favori kripto paralarını seçebilir ve bu favorileri uygulamanın üst kısmında sürekli olarak takip edebilir.
- **Anlık Fiyat Değişimi:** Kripto paraların fiyatları, anasayfada bulunan pull to refresh özelliği ile gerçek zamanlı olarak güncellenir ve kullanıcıya bildirilir.
- **Kripto Grafik Sayfası:** Kullanıcılar herhangi bir kripto paraya tıkladığında o kripto paraya ait ayrıntılı grafiğe erişebilirler.

## Sayfa Detayları

### Anasayfa
- **Görev:** Anasayfa, kullanıcıya tüm kripto paraları listeleyerek anlık değişimleri gösterir. Ayrıca, kullanıcı favori kripto paralarını üst kısımda sürekli görür ve istediği kripto parayı favorilerine ekleyebilir.
- **İşlev:** Kullanıcılar bir kripto paraya tıkladığında, o kripto paraya ait detaylı grafik sayfasına yönlendirilir.

### Kripto Grafik Sayfası
- **Görev:** Kullanıcı, herhangi bir kripto para üzerinde tıkladığında bu sayfada kripto para ile ilgili detaylı fiyat değişim grafiğini görür.
- **İşlev:** Kullanıcı, grafikteki verileri görerek kripto paranın zaman içindeki değer değişimini izler. Grafikte dinamik değişiklikler gösterilir.

## Proje Yapısı

### Architecture
- **MVVM:** Proje, MVVM (Model-View-ViewModel) Clean Architecture desenini kullanarak geliştirilmiştir. Model, View ve ViewModel arasındaki ayrım, uygulamanın daha modüler ve sürdürülebilir olmasını sağlar.
- **Clean Architecture:** Uygulama Clean Architecture prensiplerine uygun şekilde yapılandırılmıştır. Katmanlı bir yapıda, her katman belirli bir sorumluluğa sahiptir ve birbirinden bağımsızdır.

### Design Pattern
- **Coordinator:** Ekranlar arası geçişleri ve gezinmeyi merkezi bir yapıdan yönetmek için kullanılan bir tasarım desenidir. Bu pattern, her bir navigation akışını kendine özgü bir Coordinator sınıfı tarafından yönetilmesini sağlayarak, custom contentView ve component sınıflarını UI ve içerik yönetimiyle sınırlar. Böylece, navigasyon mantığı kontrolcülerden ayrılarak daha modüler, test edilebilir ve sürdürülebilir bir yapı elde edilir.

### Kullanılan Kütüphaneler

- **[Swift Charts](https://github.com/danielgindi/Charts):** Kripto paraların zaman içindeki değişimini görselleştirmek için kullanıldı.
- **[Alamofire](https://github.com/Alamofire/Alamofire):** API istekleri yapmak ve kripto para verilerini çekmek için kullanıldı.
- **[SnapKit](https://github.com/SnapKit/SnapKit):** Kullanıcı arayüzünü Auto Layout ile dinamik bir şekilde oluşturmak için kullanıldı.

## Kurulum

### Swift Package Manager ile Bağımlılıkların Yüklenmesi

Projede bağımlılık yönetimi için Swift Package Manager (SPM) kullanılmıştır.

1. Bu repo’yu klonlayın:
   ```bash
   git clone https://github.com/yahyacanozdemir/BTCTrader101.git
