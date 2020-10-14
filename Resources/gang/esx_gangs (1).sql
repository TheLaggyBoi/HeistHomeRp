CREATE TABLE if not exists `gang` (

  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,

  PRIMARY KEY (`id`)
);

INSERT INTO gang (name, label) VALUES
('none', 'Unaffiliated'),
('ballas', 'Ballas'),
('gsf', 'GrooveStreetFamily'); 

CREATE TABLE if not exists `gang_grades` (

  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gang_name` varchar(255) NOT NULL,
  `grade` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,

  PRIMARY KEY (`id`)
);


INSERT INTO gang_grades (gang_name, grade, name, label) VALUES 
('none', 0, 'none', 'no gang'), 
('ballas', 0, 'ballas2', 'recruit'),
('ballas', 1, 'ballas3', 'Nigga'),
('ballas', 2, 'ballas4', 'Dealer'), 
('ballas', 3, 'ballas5', 'Right Hand'), 
('ballas', 4, 'boss', 'Boss'), 
('gsf', 0, 'gsf1', 'recruit'), 
('gsf', 1, 'gsf2', 'Nigga'), 
('gsf', 2, 'gsf3', 'Homie'),
('gsf', 3, 'boss', 'Boss'); 