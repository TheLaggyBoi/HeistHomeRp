-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Wersja serwera:               10.4.8-MariaDB - mariadb.org binary distribution
-- Serwer OS:                    Win64
-- HeidiSQL Wersja:              10.3.0.5771
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Zrzut struktury bazy danych chuj
CREATE DATABASE IF NOT EXISTS `essentialmode` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `essentialmode`;

-- Zrzucanie danych dla tabeli chuj.fine_types: ~52 rows (około)
/*!40000 ALTER TABLE `fine_types` DISABLE KEYS */;
INSERT INTO `fine_types` (`id`, `label`, `amount`, `category`) VALUES
	(105, 'Korna kötüye kullanımı', 30, 0),
	(106, 'Sürekli hat geçişi', 40, 0),
	(107, 'Yolun yanlış tarafında sürüş', 250, 0),
	(108, 'Yanlış U dönüşü', 250, 0),
	(109, 'Yasadışı Off-Road Sürüşü', 170, 0),
	(110, 'Polis emirlerine uyulmaması', 30, 0),
	(111, 'Aracın yanlış durması', 150, 0),
	(112, 'Yanlış park', 70, 0),
	(113, 'Sağdan gelen trafiğe uymama (sol şeritte sürüş)', 70, 0),
	(114, 'Araç bilgisi yok', 90, 0),
	(115, 'STOP işaretine uyulmaması', 105, 0),
	(116, 'Kırmızı ışıkta durma', 130, 0),
	(117, 'Yetkisiz bir yerde geçme', 100, 0),
	(118, 'Yasadışı bir araç kullanmak', 100, 0),
	(119, 'Ehliyet yok', 1500, 0),
	(120, 'Etkinlikten Kaçış', 800, 0),
	(121, 'Aşırı hız <5 mil / saat', 90, 0),
	(122, 'Aşırı hız 5-15 mil', 120, 0),
	(123, 'Aşırı hız 15-30 mil', 180, 0),
	(124, 'Aşırı hız> 30 mil / saat', 300, 0),
	(125, 'Hareketi engelleme', 110, 1),
	(126, 'Kamu yararı', 90, 1),
	(127, 'Yanlış davranış', 90, 1),
	(128, 'İşlemleri engelleme', 130, 1),
	(129, 'Sivillere hakaret', 75, 1),
	(130, 'Oyunculara hakaret', 110, 1),
	(131, 'Sözlü tehditler', 90, 1),
	(132, 'Oyunculara küfür', 150, 1),
	(133, 'Yanlış bilgi sağlama', 250, 1),
	(134, 'Yolsuzluk teşebbüsü', 1500, 1),
	(135, 'Şehirde silah sallayarak gezmek', 120, 2),
	(136, 'Şehirde tehlikeli bir silah sallıyor', 300, 2),
	(137, 'Silah izni yok', 600, 2),
	(138, 'Yasadışı silah bulundurma', 700, 2),
	(139, 'Bilgisayar korsanlığı araçlarına sahip olmak', 300, 2),
	(140, 'Hırsız - tekrarlayan suçlu', 1800, 2),
	(141, 'Yasadışı maddelerin dağıtımı', 1500, 2),
	(142, 'Yasa dışı maddelerin imalatı', 1500, 2),
	(143, 'Yasaklanmış maddelerin bulundurulması', 650, 2),
	(144, 'Sivilleri kaçırmak', 1500, 2),
	(145, 'Kaçırma oyuncusu', 2000, 2),
	(146, 'Soygun', 650, 2),
	(147, 'Elinde silah olan hırsızlık', 650, 2),
	(148, 'Banka soygunu', 1500, 2),
	(149, 'Sivil saldırı', 2000, 3),
	(150, 'Oyuncuya saldırı', 2500, 3),
	(151, 'Sivil bir cinayete teşebbüs', 3000, 3),
	(152, 'Oyuncu cinayete teşebbüs', 5000, 3),
	(153, 'Bir sivilin kasıtlı suikastı', 10000, 3),
	(154, 'Kasıtlı oyuncu cinayeti', 30000, 3),
	(155, 'Yanlışlıkla ölüme neden', 1800, 3),
	(156, 'Dolandırıcılık', 2000, 2);
/*!40000 ALTER TABLE `fine_types` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
