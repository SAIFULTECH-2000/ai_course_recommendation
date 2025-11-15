-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 15, 2025 at 01:04 PM
-- Server version: 8.0.30
-- PHP Version: 8.2.29

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `flask_login_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

CREATE TABLE `course` (
  `id` int NOT NULL,
  `course_name` varchar(255) NOT NULL,
  `learning_outcome` text,
  `track_id` int NOT NULL
) ;

-- --------------------------------------------------------

--
-- Table structure for table `courses`
--

CREATE TABLE `courses` (
  `id` bigint UNSIGNED NOT NULL,
  `track_id` int NOT NULL,
  `course_name` varchar(255) NOT NULL,
  `learning_outcome` text NOT NULL
) ;

--
-- Dumping data for table `courses`
--

INSERT INTO `courses` (`id`, `track_id`, `course_name`, `learning_outcome`) VALUES
(1, 1, 'Big Data Analytics', 'Technologies and methods for processing and analysing massive datasets (e.g., Hadoop, Spark).'),
(2, 1, 'Machine Learning', 'Advanced techniques for predictive models, classification, regression, and clustering.'),
(3, 1, 'Data Visualization', 'Presenting complex data insights clearly using tools and effective design principles.'),
(4, 2, 'Computer Security', 'Principles of network and system security, access control, and authentication.'),
(5, 2, 'Information Assurance and Security', 'Maintaining confidentiality, integrity, and availability of information assets.'),
(6, 2, 'Computer Forensic / Computer Ethics and Cyber Law', 'Investigating digital crimes and understanding legal/ethical frameworks.'),
(7, 3, 'Software Requirement Engineering', 'Eliciting, analysing, and documenting software needs from stakeholders.'),
(8, 3, 'Software Design and Architecture', 'Designing robust, large-scale software systems.'),
(9, 3, 'Software Testing & Quality Assurance', 'Ensuring quality through rigorous testing methodologies.'),
(10, 4, 'Business Intelligence (BI)', 'Transforming raw business data into meaningful, useful insights.'),
(11, 4, 'Enterprise System Development', 'Developing and managing large-scale applications such as ERP.'),
(12, 4, 'IT Audit & Risk Management', 'Managing IT risks and ensuring compliance.');

-- --------------------------------------------------------

--
-- Table structure for table `questionnaires`
--

CREATE TABLE `questionnaires` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `interests` text,
  `tasks` text,
  `confidence` int DEFAULT NULL,
  `work_preference` varchar(50) DEFAULT NULL,
  `suggested_major` varchar(100) DEFAULT NULL
);

--
-- Dumping data for table `questionnaires`
--

INSERT INTO `questionnaires` (`id`, `user_id`, `interests`, `tasks`, `confidence`, `work_preference`, `suggested_major`) VALUES
(1, 1, 'Artificial Intelligence', 'Logical problem-solving', 1, 'Individual', 'Information Technology'),
(2, 1, 'Data Science', 'Logical problem-solving,Creative design', 5, '', 'Data Analytics'),
(3, 1, 'Software Engineering,Business Analytics,Networking', 'Logical problem-solving,Creative design', 3, 'Individual', 'Software Engineering'),
(4, 1, 'Artificial Intelligence,Data Science,Business Analytics,Networking,Cybersecurity', 'Analyzing data,Research and experimentation', 5, 'Team-based', 'Data Analytics'),
(5, 1, 'Artificial Intelligence,Data Science', 'Creative design,Managing projects or teams', 5, 'Individual', 'Data Analytics'),
(6, 1, 'Cybersecurity,Data Science', 'Logical problem-solving,Analyzing data,Creative design,Managing projects or teams,Research and experimentation', 4, 'Individual', 'Data Analytics'),
(7, 1, 'Cybersecurity,Data Science', 'Logical problem-solving,Analyzing data,Creative design,Managing projects or teams,Research and experimentation', 4, 'Individual', 'Data Analytics'),
(8, 1, 'Software Engineering,Data Science', 'Logical problem-solving,Analyzing data', 5, 'Individual', 'Data Science'),
(9, 1, 'Software Engineering,Data Science', 'Logical problem-solving', 5, 'Individual', 'Software Engineering'),
(10, 1, 'Software Engineering,Data Science', 'Logical problem-solving', 5, 'Individual', 'Software Engineering');

-- --------------------------------------------------------

--
-- Table structure for table `relevant_field_details`
--

CREATE TABLE `relevant_field_details` (
  `id` bigint UNSIGNED NOT NULL,
  `track_id` bigint UNSIGNED NOT NULL,
  `field_name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `difficulty` enum('Beginner','Intermediate','Advanced') DEFAULT 'Beginner',
  `category` varchar(255) DEFAULT NULL,
  `why_recommended` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ;

--
-- Dumping data for table `relevant_field_details`
--

INSERT INTO `relevant_field_details` (`id`, `track_id`, `field_name`, `description`, `difficulty`, `category`, `why_recommended`, `created_at`) VALUES
(1, 1, 'Data Science', 'Focuses on extracting insights from structured and unstructured data using statistics, programming, and analytics techniques.', 'Advanced', 'AI & Analytics', 'High demand in AI, automation, and decision-making roles across all industries.', '2025-11-15 06:24:04'),
(2, 1, 'Business Analytics', 'Uses data-driven insights and analytical tools to support business decisions and strategic planning.', 'Intermediate', 'Business & Analytics', 'Ideal for roles such as Business Analyst, Data Consultant, and Operations Analyst.', '2025-11-15 06:24:04'),
(3, 1, 'AI', 'Artificial Intelligence develops systems capable of performing tasks that typically require human intelligence, such as learning and reasoning.', 'Advanced', 'AI & Machine Learning', 'Rapidly growing field powering automation, robotics, and smart applications.', '2025-11-15 06:24:04'),
(4, 2, 'Cybersecurity', 'Protects systems, networks, and data from cyber threats through security protocols and risk mitigation.', 'Advanced', 'Security & Networking', 'High global demand due to increasing cyber attacks and data protection regulations.', '2025-11-15 06:24:04'),
(5, 2, 'Networking', 'Focuses on communication between computer systems, including routing, switching, and network security.', 'Intermediate', 'IT Infrastructure', 'Essential skill for IT infrastructure, cloud computing, and network operations careers.', '2025-11-15 06:24:04'),
(6, 3, 'Software Engineering', 'Applies engineering principles to design, develop, test, and maintain software systems.', 'Intermediate', 'Software Development', 'Core skill for developers, QA engineers, and large-scale system development teams.', '2025-11-15 06:24:04'),
(7, 4, 'Business Analytics', 'Uses data-driven insights and analytical tools to support business decisions and strategic planning.', 'Intermediate', 'Business & Analytics', 'Ideal for roles such as Business Analyst, Data Consultant, and Operations Analyst.', '2025-11-15 06:24:04'),
(8, 5, 'Software Engineering', 'Applies engineering principles to design, develop, and maintain software systems.', 'Intermediate', 'Software Development', 'Core skill for developers, QA engineers, and large-scale software projects.', '2025-11-15 12:57:55'),
(9, 5, 'Programming', 'Focuses on writing efficient, maintainable, and robust code using various programming languages.', 'Intermediate', 'Software Development', 'Essential for building and maintaining software applications.', '2025-11-15 12:57:55'),
(10, 5, 'System Design', 'Covers designing software architectures, components, and scalable systems.', 'Advanced', 'Software Development', 'Critical for creating scalable, maintainable, and high-performing systems.', '2025-11-15 12:57:55');

-- --------------------------------------------------------

--
-- Table structure for table `student_gpa_trend`
--

CREATE TABLE `student_gpa_trend` (
  `id` int NOT NULL,
  `student_id` int NOT NULL,
  `semester` varchar(10) NOT NULL,
  `gpa` decimal(3,2) NOT NULL
) ;

--
-- Dumping data for table `student_gpa_trend`
--

INSERT INTO `student_gpa_trend` (`id`, `student_id`, `semester`, `gpa`) VALUES
(1, 1, 'Sem 1', '1.50'),
(2, 1, 'Sem 2', '2.00'),
(3, 1, 'Sem 3', '2.60'),
(4, 1, 'Sem 4', '3.10'),
(5, 1, 'Sem 5', '3.40'),
(6, 1, 'Sem 6', '3.70'),
(7, 1, 'Sem 7', '3.90');

-- --------------------------------------------------------

--
-- Table structure for table `study_plan`
--

CREATE TABLE `study_plan` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `field_id` int NOT NULL,
  `created_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `study_plan`
--

INSERT INTO `study_plan` (`id`, `user_id`, `field_id`, `created_at`) VALUES
(4, 1, 3, '2025-11-15 20:43:36');

-- --------------------------------------------------------

--
-- Table structure for table `track`
--

CREATE TABLE `track` (
  `id` int NOT NULL,
  `track_name` varchar(255) NOT NULL,
  `relevant_fields` json DEFAULT NULL
) ;

-- --------------------------------------------------------

--
-- Table structure for table `tracks`
--

CREATE TABLE `tracks` (
  `id` bigint UNSIGNED NOT NULL,
  `track_name` varchar(255) NOT NULL,
  `relevant_fields` json NOT NULL,
  `whyrecommand` text NOT NULL
) ;

--
-- Dumping data for table `tracks`
--

INSERT INTO `tracks` (`id`, `track_name`, `relevant_fields`, `whyrecommand`) VALUES
(1, 'Data Analytics', '[\"Data Science\", \"Business Analytics\", \"AI\"]', 'This track is recommended for students interested in Data Science and Business Analytics, covering skills like Python programming, machine learning, statistics, data visualization, business intelligence, and data analysis. Ideal for those who want to analyze data and make informed decisions.'),
(2, 'Cyber Security', '[\"Cybersecurity\", \"Networking\"]', 'Recommended for students passionate about Cybersecurity and Networking. Students will gain skills in network security, ethical hacking, cryptography, and routing & switching, preparing them to protect systems and networks from threats.'),
(3, 'Software Quality', '[\"Software Engineering\"]', 'Best suited for students interested in Software Engineering. Covers software design, algorithms, OOP, and database systems, focusing on improving software quality, reliability, and maintainability.'),
(4, 'Enterprise Systems', '[\"Business Analytics\"]', 'Ideal for students aiming to understand Business Analytics and enterprise-level systems. Students learn business intelligence, data analysis, statistics, and Excel/Power BI to manage and optimize business operations.'),
(5, 'Software Engineering', '[\"Software Engineering\", \"Programming\", \"System Design\"]', 'Ideal for students interested in building, testing, and maintaining software systems.');

-- --------------------------------------------------------

--
-- Table structure for table `track_result`
--

CREATE TABLE `track_result` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `courses_id` int NOT NULL,
  `result` enum('A+','A','A-','B+','B','B-','C+','C','C-','D','F') DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `program` varchar(255) DEFAULT NULL,
  `faculty` varchar(255) DEFAULT NULL,
  `learning_style` varchar(255) DEFAULT NULL,
  `work_preference` varchar(255) DEFAULT NULL,
  `career_goal` varchar(255) DEFAULT NULL,
  `industry` varchar(255) DEFAULT NULL
) ;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `username` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `learning_style` varchar(255) DEFAULT NULL,
  `work_preference` varchar(255) DEFAULT NULL,
  `career_goal` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `program` varchar(255) DEFAULT NULL,
  `faculty` varchar(255) DEFAULT NULL,
  `industry` varchar(255) DEFAULT NULL,
  `gpa` float DEFAULT NULL,
  `credit_hours` int DEFAULT NULL,
  `semester` int DEFAULT NULL
) ;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `learning_style`, `work_preference`, `career_goal`, `email`, `program`, `faculty`, `industry`, `gpa`, `credit_hours`, `semester`) VALUES
(1, 'Shafril', 'pbkdf2:sha256:260000$6aA6oTr9MoMU559O$a67963f23188a782c4c6fc39f6a6422e64d21ed151ad00be4650ff48ad8b6f53', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 'SAIFULNIZAM2', 'pbkdf2:sha256:260000$16ICe7RQF8yNlNiM$5c112ed5912c4fcd196abb917a2af38d60216d02763b2c6e8a797d44865d6b7b', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_tracks`
--

CREATE TABLE `user_tracks` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` int NOT NULL,
  `track_id` int NOT NULL
) ;

--
-- Dumping data for table `user_tracks`
--

INSERT INTO `user_tracks` (`id`, `user_id`, `track_id`) VALUES
(1, 123, 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `course`
--
ALTER TABLE `course`
  ADD PRIMARY KEY (`id`),
  ADD KEY `track_id` (`track_id`);

--
-- Indexes for table `courses`
--
ALTER TABLE `courses`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `questionnaires`
--
ALTER TABLE `questionnaires`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `relevant_field_details`
--
ALTER TABLE `relevant_field_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `track_id` (`track_id`);

--
-- Indexes for table `student_gpa_trend`
--
ALTER TABLE `student_gpa_trend`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `study_plan`
--
ALTER TABLE `study_plan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `track`
--
ALTER TABLE `track`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `track_name` (`track_name`);

--
-- Indexes for table `tracks`
--
ALTER TABLE `tracks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `track_result`
--
ALTER TABLE `track_result`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `user_tracks`
--
ALTER TABLE `user_tracks`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `course`
--
ALTER TABLE `course`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `courses`
--
ALTER TABLE `courses`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `questionnaires`
--
ALTER TABLE `questionnaires`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `relevant_field_details`
--
ALTER TABLE `relevant_field_details`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `student_gpa_trend`
--
ALTER TABLE `student_gpa_trend`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `study_plan`
--
ALTER TABLE `study_plan`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `track`
--
ALTER TABLE `track`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tracks`
--
ALTER TABLE `tracks`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `track_result`
--
ALTER TABLE `track_result`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `user_tracks`
--
ALTER TABLE `user_tracks`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `course`
--
ALTER TABLE `course`
  ADD CONSTRAINT `course_ibfk_1` FOREIGN KEY (`track_id`) REFERENCES `track` (`id`);

--
-- Constraints for table `questionnaires`
--
ALTER TABLE `questionnaires`
  ADD CONSTRAINT `questionnaires_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `relevant_field_details`
--
ALTER TABLE `relevant_field_details`
  ADD CONSTRAINT `relevant_field_details_ibfk_1` FOREIGN KEY (`track_id`) REFERENCES `tracks` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `study_plan`
--
ALTER TABLE `study_plan`
  ADD CONSTRAINT `study_plan_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
