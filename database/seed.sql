-- ===================================================================
-- DepartmentHub Database Seed Data (Pakistani Institutional Context)
-- AI-Powered Department Management & Intelligence Platform
-- Realistic Seed Dataset for Pakistan Higher Education Context
-- Default Password for all seeded users: Password123!
-- ===================================================================

USE departmenthub_db;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE reports;
TRUNCATE TABLE revenue_goals;
TRUNCATE TABLE budgets;
TRUNCATE TABLE expenses;
TRUNCATE TABLE revenue;
TRUNCATE TABLE request_comments;
TRUNCATE TABLE request_history;
TRUNCATE TABLE requests;
TRUNCATE TABLE inventory_assignments;
TRUNCATE TABLE inventory;
TRUNCATE TABLE enrollments;
TRUNCATE TABLE courses;
TRUNCATE TABLE faculty;
TRUNCATE TABLE students;
TRUNCATE TABLE users;
TRUNCATE TABLE departments;

SET FOREIGN_KEY_CHECKS = 1;

-- -------------------------------------------------------------------
-- 1. DEPARTMENT
-- -------------------------------------------------------------------
INSERT INTO departments (id, name, code, building) VALUES
(1, 'Department of Computer Science & Software Engineering', 'CS-SE', 'Al-Khawarizmi Computing Complex - CS Wing');

-- -------------------------------------------------------------------
-- 2. USERS (Admin, Officer, Faculty, Staff with Pakistani Identities)
-- Bcrypt Hash for 'Password123!': $2a$10$w8T05/Nq7g5c5jVzD7O7yeV6gJ70qV.zYy49qHw39fE4.KqP6b43q
-- -------------------------------------------------------------------
INSERT INTO users (id, department_id, name, email, password_hash, role, avatar_url, is_active) VALUES
(1, 1, 'Dr. Khurram Nadeem', 'admin@departmenthub.edu', '$2a$10$w8T05/Nq7g5c5jVzD7O7yeV6gJ70qV.zYy49qHw39fE4.KqP6b43q', 'admin', 'https://images.unsplash.com/photo-1537368910025-700350fe46c7?w=150', TRUE),
(2, 1, 'Syed Muhammad Ali', 'officer@departmenthub.edu', '$2a$10$w8T05/Nq7g5c5jVzD7O7yeV6gJ70qV.zYy49qHw39fE4.KqP6b43q', 'officer', 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150', TRUE),
(3, 1, 'Dr. Ayesha Khan', 'faculty@departmenthub.edu', '$2a$10$w8T05/Nq7g5c5jVzD7O7yeV6gJ70qV.zYy49qHw39fE4.KqP6b43q', 'faculty', 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150', TRUE),
(4, 1, 'Muhammad Rizwan', 'staff@departmenthub.edu', '$2a$10$w8T05/Nq7g5c5jVzD7O7yeV6gJ70qV.zYy49qHw39fE4.KqP6b43q', 'staff', 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150', TRUE),
(5, 1, 'Dr. Rimsha Ahmad', 'rimsha.ahmad@departmenthub.edu', '$2a$10$w8T05/Nq7g5c5jVzD7O7yeV6gJ70qV.zYy49qHw39fE4.KqP6b43q', 'faculty', 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=150', TRUE),
(6, 1, 'Engr. Abdul Moeez', 'abdul.moeez@departmenthub.edu', '$2a$10$w8T05/Nq7g5c5jVzD7O7yeV6gJ70qV.zYy49qHw39fE4.KqP6b43q', 'faculty', 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150', TRUE);

-- -------------------------------------------------------------------
-- 3. FACULTY (10 Pakistani Faculty Members)
-- -------------------------------------------------------------------
INSERT INTO faculty (id, department_id, user_id, name, email, designation, office, max_workload, current_workload) VALUES
(1, 1, 1, 'Dr. Khurram Nadeem', 'admin@departmenthub.edu', 'Professor & Dean', 'Dean Office - AK-301', 12, 6),
(2, 1, 3, 'Dr. Ayesha Khan', 'faculty@departmenthub.edu', 'Professor & HoD CS', 'Room AK-305', 12, 9),
(3, 1, 5, 'Dr. Rimsha Ahmad', 'rimsha.ahmad@departmenthub.edu', 'Associate Professor', 'Room AK-309', 12, 12),
(4, 1, 6, 'Engr. Abdul Moeez', 'abdul.moeez@departmenthub.edu', 'Assistant Professor', 'Room AK-312', 12, 9),
(5, 1, NULL, 'Dr. Tariq Mahmood', 'tariq.mahmood@departmenthub.edu', 'Professor & Director AI Lab', 'Lab AK-104', 12, 9),
(6, 1, NULL, 'Dr. Zainab Bibi', 'zainab.bibi@departmenthub.edu', 'Associate Professor', 'Room AK-322', 12, 6),
(7, 1, NULL, 'Dr. Usman Farooq', 'usman.farooq@departmenthub.edu', 'Associate Professor', 'Room AK-325', 12, 9),
(8, 1, NULL, 'Engr. Hamza Malik', 'hamza.malik@departmenthub.edu', 'Lecturer', 'Room AK-330', 12, 9),
(9, 1, NULL, 'Dr. Fatima Noor', 'fatima.noor@departmenthub.edu', 'Assistant Professor', 'Room AK-334', 12, 6),
(10, 1, NULL, 'Engr. Bilal Hassan', 'bilal.hassan@departmenthub.edu', 'Lecturer & Lab Director', 'Lab AK-101', 15, 12);

-- -------------------------------------------------------------------
-- 4. COURSES (12 Pakistani Degree Courses)
-- -------------------------------------------------------------------
INSERT INTO courses (id, department_id, course_code, name, credit_hours, instructor_id, semester, room, schedule, max_enrollment, enrollment_count) VALUES
(1, 1, 'CS101', 'Programming Fundamentals (C/C++)', 3, 2, 'Fall 2026', 'Auditorium 1', 'Mon/Wed 08:30 - 10:00', 60, 52),
(2, 1, 'CS201', 'Object Oriented Programming & Data Structures', 4, 3, 'Fall 2026', 'Hall AK-201', 'Tue/Thu 10:00 - 12:00', 50, 48),
(3, 1, 'CS301', 'Database Systems & SQL Management', 3, 6, 'Fall 2026', 'Lab AK-102', 'Mon/Wed 11:30 - 13:00', 40, 39),
(4, 1, 'CS305', 'Operating Systems & Linux Kernel', 4, 4, 'Fall 2026', 'Hall AK-205', 'Tue/Thu 13:00 - 15:00', 40, 37),
(5, 1, 'CS310', 'Data Communication & Computer Networks', 3, 7, 'Fall 2026', 'Hall AK-203', 'Fri 09:00 - 12:00', 45, 43),
(6, 1, 'CS401', 'Artificial Intelligence & Deep Learning', 3, 5, 'Fall 2026', 'Lab AK-104 (AI Lab)', 'Mon/Wed 14:00 - 15:30', 35, 34),
(7, 1, 'CS405', 'Cloud Computing & Distributed Systems', 3, 9, 'Fall 2026', 'Hall AK-208', 'Tue/Thu 15:30 - 17:00', 35, 31),
(8, 1, 'CS412', 'Software Engineering & Agile Methodologies', 3, 4, 'Fall 2026', 'Hall AK-204', 'Mon/Wed 16:00 - 17:30', 40, 38),
(9, 1, 'CS420', 'Theory of Automata & Formal Languages', 3, 1, 'Fall 2026', 'Hall AK-210', 'Tue/Thu 08:30 - 10:00', 30, 26),
(10, 1, 'CS450', 'Information Security & Ethical Hacking', 3, 7, 'Fall 2026', 'Lab AK-106', 'Fri 14:00 - 17:00', 35, 32),
(11, 1, 'CS490', 'Final Year Capstone Project (FYP-I)', 3, 8, 'Fall 2026', 'Seminar Hall B', 'Wed 13:00 - 16:00', 40, 39),
(12, 1, 'CS102', 'Computing Applications & Digital Logic Lab', 2, 10, 'Fall 2026', 'Lab AK-101', 'Tue/Thu 14:00 - 16:00', 30, 28);

-- -------------------------------------------------------------------
-- 5. STUDENTS (35 Realistic Pakistani Student Records)
-- -------------------------------------------------------------------
INSERT INTO students (id, department_id, student_id, name, email, program, semester, gpa, status, phone) VALUES
(1, 1, '2023-CS-041', 'Abdul Moeez', 'abdul.moeez@student.edu.pk', 'BS Computer Science', 6, 3.88, 'active', '+92 300 8451201'),
(2, 1, '2023-CS-012', 'Rimsha Ahmad', 'rimsha.ahmad@student.edu.pk', 'BS Computer Science', 6, 3.94, 'active', '+92 321 4567890'),
(3, 1, '2023-SE-089', 'Muhammad Ali', 'muhammad.ali@student.edu.pk', 'BS Software Engineering', 6, 3.65, 'active', '+92 333 9876543'),
(4, 1, '2024-AI-015', 'Ayesha Khan', 'ayesha.khan@student.edu.pk', 'BS Artificial Intelligence', 4, 3.82, 'active', '+92 345 1234567'),
(5, 1, '2024-CS-022', 'Hamza Tariq', 'hamza.tariq@student.edu.pk', 'BS Computer Science', 4, 3.70, 'active', '+92 301 7654321'),
(6, 1, '2024-SE-034', 'Zainab Fatima', 'zainab.fatima@student.edu.pk', 'BS Software Engineering', 4, 3.91, 'active', '+92 312 3456789'),
(7, 1, '2025-CS-008', 'Bilal Ahmed', 'bilal.ahmed@student.edu.pk', 'BS Computer Science', 2, 3.40, 'active', '+92 302 9876543'),
(8, 1, '2025-AI-019', 'Mahnoor Siddiqui', 'mahnoor.s@student.edu.pk', 'BS Artificial Intelligence', 2, 3.96, 'active', '+92 322 8765432'),
(9, 1, '2025-CS-045', 'Hassan Raza', 'hassan.raza@student.edu.pk', 'BS Computer Science', 2, 2.45, 'active', '+92 334 7654321'),
(10, 1, '2025-SE-062', 'Iqra Javed', 'iqra.javed@student.edu.pk', 'BS Software Engineering', 2, 3.75, 'active', '+92 346 6543210'),
(11, 1, '2022-CS-101', 'Usman Ghani', 'usman.ghani@student.edu.pk', 'BS Computer Science', 8, 3.62, 'active', '+92 300 5432109'),
(12, 1, '2022-AI-077', 'Hafsa Rehman', 'hafsa.rehman@student.edu.pk', 'BS Artificial Intelligence', 8, 3.90, 'active', '+92 321 4321098'),
(13, 1, '2022-SE-055', 'Shahzaib Khan', 'shahzaib.k@student.edu.pk', 'BS Software Engineering', 8, 3.35, 'active', '+92 333 3210987'),
(14, 1, '2023-CS-098', 'Anum Zahra', 'anum.zahra@student.edu.pk', 'BS Computer Science', 5, 3.72, 'active', '+92 345 2109876'),
(15, 1, '2023-AI-033', 'Daniyal Aslam', 'daniyal.aslam@student.edu.pk', 'BS Artificial Intelligence', 5, 3.55, 'active', '+92 301 1098765'),
(16, 1, '2023-SE-019', 'Laiba Noor', 'laiba.noor@student.edu.pk', 'BS Software Engineering', 5, 3.80, 'active', '+92 312 0987654'),
(17, 1, '2024-CS-067', 'Omer Farooq', 'omer.farooq@student.edu.pk', 'BS Computer Science', 3, 3.60, 'active', '+92 302 9876541'),
(18, 1, '2024-AI-082', 'Sana Ullah', 'sana.ullah@student.edu.pk', 'BS Artificial Intelligence', 3, 3.48, 'active', '+92 322 8765430'),
(19, 1, '2024-SE-041', 'Zeeshan Akram', 'zeeshan.akram@student.edu.pk', 'BS Software Engineering', 3, 3.25, 'active', '+92 334 7654329'),
(20, 1, '2025-CS-014', 'Mariam Bibi', 'mariam.bibi@student.edu.pk', 'BS Computer Science', 1, 3.85, 'active', '+92 346 6543218'),
(21, 1, '2025-AI-059', 'Fahad Mustafa', 'fahad.mustafa@student.edu.pk', 'BS Artificial Intelligence', 1, 3.68, 'active', '+92 300 5432107'),
(22, 1, '2025-SE-028', 'Khadija Tul Kubra', 'khadija.kubra@student.edu.pk', 'BS Software Engineering', 1, 3.92, 'active', '+92 321 4321096'),
(23, 1, '2022-CS-018', 'Taimoor Shah', 'taimoor.shah@student.edu.pk', 'BS Computer Science', 7, 3.50, 'active', '+92 333 3210985'),
(24, 1, '2022-AI-091', 'Nimra Tariq', 'nimra.tariq@student.edu.pk', 'BS Artificial Intelligence', 7, 3.87, 'active', '+92 345 2109874'),
(25, 1, '2022-SE-063', 'Ali Shan', 'ali.shan@student.edu.pk', 'BS Software Engineering', 7, 3.42, 'active', '+92 301 1098763'),
(26, 1, '2023-CS-072', 'Sumbul Riaz', 'sumbul.riaz@student.edu.pk', 'BS Computer Science', 6, 3.79, 'active', '+92 312 0987652'),
(27, 1, '2023-AI-044', 'Waleed Akhtar', 'waleed.akhtar@student.edu.pk', 'BS Artificial Intelligence', 6, 3.83, 'active', '+92 302 9876549'),
(28, 1, '2023-SE-080', 'Sadia Perveen', 'sadia.perveen@student.edu.pk', 'BS Software Engineering', 6, 3.67, 'active', '+92 322 8765438'),
(29, 1, '2024-CS-011', 'Asad Ullah', 'asad.ullah@student.edu.pk', 'BS Computer Science', 4, 3.58, 'active', '+92 334 7654327'),
(30, 1, '2024-AI-029', 'Momina Basit', 'momina.basit@student.edu.pk', 'BS Artificial Intelligence', 4, 3.91, 'active', '+92 346 6543216'),
(31, 1, '2024-SE-095', 'Haris Mehmood', 'haris.m@student.edu.pk', 'BS Software Engineering', 4, 3.45, 'active', '+92 300 5432105'),
(32, 1, '2025-CS-083', 'Farhan Qureshi', 'farhan.q@student.edu.pk', 'BS Computer Science', 2, 3.76, 'active', '+92 321 4321094'),
(33, 1, '2025-AI-066', 'Bushra Naeem', 'bushra.naeem@student.edu.pk', 'BS Artificial Intelligence', 2, 3.89, 'active', '+92 333 3210983'),
(34, 1, '2025-SE-037', 'Junaid Jamshed', 'junaid.j@student.edu.pk', 'BS Software Engineering', 2, 3.32, 'active', '+92 345 2109872'),
(35, 1, '2022-CS-005', 'Samina Baig', 'samina.baig@student.edu.pk', 'BS Computer Science', 8, 3.97, 'active', '+92 301 1098761');

-- -------------------------------------------------------------------
-- 6. ENROLLMENTS (Realistic Course Enrollments)
-- -------------------------------------------------------------------
INSERT INTO enrollments (student_id, course_id, grade, semester) VALUES
(1, 1, 'A', 'Fall 2026'),
(1, 2, 'A', 'Fall 2026'),
(1, 6, 'A', 'Fall 2026'),
(2, 2, 'A', 'Fall 2026'),
(2, 3, 'A', 'Fall 2026'),
(3, 4, 'B+', 'Fall 2026'),
(3, 8, 'A-', 'Fall 2026'),
(4, 6, 'A', 'Fall 2026'),
(5, 1, 'B+', 'Fall 2026'),
(5, 5, 'A-', 'Fall 2026'),
(6, 8, 'A', 'Fall 2026'),
(7, 1, 'B', 'Fall 2026'),
(8, 6, 'A', 'Fall 2026'),
(9, 1, 'C+', 'Fall 2026'),
(10, 1, 'A-', 'Fall 2026'),
(11, 11, 'A', 'Fall 2026'),
(12, 11, 'A', 'Fall 2026'),
(13, 11, 'B+', 'Fall 2026'),
(14, 5, 'A-', 'Fall 2026'),
(15, 6, 'B+', 'Fall 2026'),
(16, 8, 'A', 'Fall 2026'),
(17, 2, 'B', 'Fall 2026'),
(18, 2, 'A', 'Fall 2026'),
(19, 2, 'C', 'Fall 2026'),
(20, 1, 'B+', 'Fall 2026');

-- -------------------------------------------------------------------
-- 7. INVENTORY (22 Inventory Records with Realistic PKR Valuations)
-- -------------------------------------------------------------------
INSERT INTO inventory (id, department_id, item_name, category, total_quantity, available_quantity, assigned_quantity, `condition`, purchase_date, purchase_value, location) VALUES
(1, 1, 'Dell OptiPlex 7090 Core i7 Workstations', 'Computers', 25, 20, 5, 'Good', '2025-08-15', 6875000.00, 'Lab AK-101'),
(2, 1, 'Apple MacBook Pro 16" M3 Max (Faculty Edition)', 'Computers', 8, 2, 6, 'Good', '2025-11-20', 6158000.00, 'Faculty Offices'),
(3, 1, 'Lenovo ThinkPad P16 Gen 2 Workstations', 'Computers', 12, 4, 8, 'Good', '2025-09-10', 5808000.00, 'Faculty Offices'),
(4, 1, 'NVIDIA RTX 4090 24GB AI Deep Learning Nodes', 'Lab Equipment', 6, 5, 1, 'Good', '2025-12-05', 4366000.00, 'Lab AK-104 (AI Lab)'),
(5, 1, 'Epson 4K Laser Lecture Projectors', 'Projectors', 8, 7, 1, 'Good', '2025-06-18', 2638000.00, 'Lecture Halls'),
(6, 1, 'BenQ High-Lumen Seminar Room Projector', 'Projectors', 4, 3, 1, 'Fair', '2024-03-12', 1055000.00, 'Seminar Rooms'),
(7, 1, 'HP LaserJet Enterprise High-Volume Network Printer', 'Printers', 5, 5, 0, 'Good', '2025-01-20', 1868000.00, 'Dept Admin Office'),
(8, 1, 'Kyocera ECOSYS Color Network Heavy Printer', 'Printers', 3, 2, 1, 'Damaged', '2023-11-15', 851000.00, 'Faculty Lounge'),
(9, 1, 'Cisco Catalyst 9300 48-Port Layer-3 Switches', 'Networking', 6, 6, 0, 'Good', '2025-04-10', 4222000.00, 'Server Room AK-01'),
(10, 1, 'Ubiquiti UniFi WiFi 6 Enterprise Access Points', 'Networking', 15, 12, 3, 'Good', '2025-05-22', 920000.00, 'Al-Khawarizmi Block'),
(11, 1, 'Rigol DS1054Z 4-Channel Digital Oscilloscopes', 'Lab Equipment', 10, 8, 2, 'Good', '2024-10-18', 877000.00, 'Hardware Lab AK-103'),
(12, 1, 'Formlabs Form 3+ High-Precision 3D SLA Printer', 'Lab Equipment', 2, 2, 0, 'Good', '2025-02-14', 1539000.00, 'Robotics Lab AK-105'),
(13, 1, 'Samsung Flip Pro 75" 4K Smart Interactive Displays', 'Projectors', 4, 4, 0, 'Good', '2025-07-28', 2639000.00, 'Conference Room 1'),
(14, 1, 'Master Ergonomic Executive Faculty Chairs', 'Furniture', 30, 24, 6, 'Good', '2025-01-15', 1800000.00, 'Faculty Offices'),
(15, 1, 'Interwood Electric Adjustable Standing Workdesks', 'Furniture', 20, 16, 4, 'Good', '2025-02-01', 1950000.00, 'Research Suites'),
(16, 1, 'Magnetic Mobile Glass Whiteboards 6x4', 'Furniture', 15, 15, 0, 'Good', '2025-03-05', 675000.00, 'Classrooms'),
(17, 1, 'Dell UltraSharp 32" 4K HDR Color Monitors', 'Computers', 20, 14, 6, 'Good', '2025-08-10', 3075000.00, 'Faculty & Lab AK-104'),
(18, 1, 'Homage 10kVA Online Server UPS Backup System', 'Networking', 3, 3, 0, 'Good', '2024-08-12', 1950000.00, 'Server Room AK-01'),
(19, 1, 'Raspberry Pi 5 8GB Complete IoT Starter Kits', 'Lab Equipment', 40, 32, 8, 'Good', '2025-09-01', 1056000.00, 'IoT Lab AK-107'),
(20, 1, 'Office Stationery, Markers & A4 Paper Bundles', 'Stationery', 50, 42, 8, 'Good', '2026-01-10', 275000.00, 'Supply Room'),
(21, 1, 'Logitech Rally Plus 4K Video Conference Suite', 'Projectors', 3, 2, 1, 'Good', '2025-04-18', 1979000.00, 'Executive Boardroom'),
(22, 1, 'HP 87A High-Yield Original Toner Cartridges', 'Stationery', 16, 11, 5, 'Good', '2026-02-05', 774000.00, 'Supply Room');

-- -------------------------------------------------------------------
-- 8. INVENTORY ASSIGNMENTS
-- -------------------------------------------------------------------
INSERT INTO inventory_assignments (id, inventory_id, assigned_to_user_id, assigned_to_location, quantity, assigned_date, return_date, status) VALUES
(1, 2, 3, 'Room AK-305', 1, '2025-11-22', NULL, 'active'),
(2, 2, 5, 'Room AK-309', 1, '2025-11-25', NULL, 'active'),
(3, 3, 6, 'Room AK-312', 1, '2025-09-15', NULL, 'active'),
(4, 14, 3, 'Room AK-305', 1, '2025-01-20', NULL, 'active'),
(5, 14, 5, 'Room AK-309', 1, '2025-01-20', NULL, 'active'),
(6, 17, 3, 'Room AK-305', 2, '2025-08-15', NULL, 'active');

-- -------------------------------------------------------------------
-- 9. REQUESTS (32 Realistic Pakistani Context Requests)
-- -------------------------------------------------------------------
INSERT INTO requests (id, department_id, requester_id, title, description, type, status, priority, assigned_to, ai_summary, ai_extracted_data, created_at) VALUES
(1, 1, 3, 'We need 5 new desktop computers for the AI laboratory.', 'Due to increased enrollment in CS401 (AI & Deep Learning), our current workstations in Lab AK-104 are fully occupied. We require 5 additional high-performance desktop computers equipped with dedicated NVIDIA GPUs for student deep learning capstone projects.', 'purchase', 'approved', 'high', 2, 'Purchase request for 5 Core i7 desktop workstations with GPU accelerators for Lab AK-104 to support CS401 enrollment growth.', '{"category": "Computers", "item": "Desktop Workstations", "quantity": 5, "purpose": "AI Laboratory expansion", "estimated_cost": 1850000, "priority": "high"}', '2026-01-15 09:30:00'),
(2, 1, 5, 'Annual Leave Request for IEEE INMIC Conference (Karachi)', 'Requesting 4 days academic leave from March 15 to March 18 to present our accepted research paper on Edge AI at IEEE INMIC in Karachi.', 'leave', 'approved', 'medium', 1, 'Academic leave request for Dr. Rimsha Ahmad for 4 days (March 15-18) to present paper at IEEE INMIC Karachi.', '{"dates": {"start": "2026-03-15", "end": "2026-03-18"}, "purpose": "IEEE INMIC Presentation", "location": "Karachi, Pakistan"}', '2026-01-20 14:15:00'),
(3, 1, 6, 'Lab AK-102 Dawlance 4-Ton Inverter AC Repair', 'The primary floor-standing 4-Ton AC unit in Lab AK-102 is leaking water near the server rack corner and making compressor noise. Urgent repair required before heat impacts workstations.', 'maintenance', 'approved', 'urgent', 2, 'Urgent HVAC maintenance request for Lab AK-102 Dawlance AC unit due to water leak adjacent to server rack.', '{"location": "Lab AK-102", "issue": "Dawlance AC water leak & compressor noise", "urgency": "urgent"}', '2026-02-01 10:00:00'),
(4, 1, 4, 'Procurement of High-Capacity Toner Cartridges & A4 Paper Bundles', 'Requesting approval to replenish office supplies: 15 boxes of Double-A A4 paper and 4 high-yield HP toner cartridges for the main CS department office printer.', 'purchase', 'approved', 'low', 2, 'Office supply replenishment: 15 boxes A4 paper and 4 HP toner cartridges for CS department administration.', '{"category": "Stationery", "items": [{"name": "A4 Paper Boxes", "quantity": 15}, {"name": "HP Toner Cartridges", "quantity": 4}], "estimated_cost": 210000}', '2026-02-05 11:45:00'),
(5, 1, 3, 'Curriculum Revision for CS401 (GenAI & LLM Modules)', 'Proposing to update the syllabus for CS401 (Artificial Intelligence) to include modern Transformer architectures, LangChain, and RAG pipelines for HEC compliance.', 'general', 'approved', 'medium', 1, 'Curriculum update proposal to modernize CS401 syllabus with Generative AI and Transformer architectures.', '{"course": "CS401", "action": "Curriculum update", "topics": ["GenAI", "Transformers", "RAG"]}', '2026-02-10 16:20:00'),
(6, 1, 5, 'Replacement Projector Bulb for Hall AK-201', 'The multimedia projector in Lecture Hall AK-201 shows a bulb warning and flickers during morning lectures of CS201.', 'maintenance', 'approved', 'high', 2, 'Maintenance request to replace flickering projector bulb in Hall AK-201.', '{"location": "Hall AK-201", "equipment": "Multimedia Projector Bulb", "issue": "Flickering and bulb life warning"}', '2026-02-12 08:50:00'),
(7, 1, 6, 'Medical Leave Request due to Viral Fever', 'Requesting 2 days sick leave from February 18 to February 19 due to seasonal viral fever. Makeup lectures for CS305 will be conducted next week.', 'leave', 'approved', 'medium', 1, 'Sick leave request for Engr. Abdul Moeez for 2 days (Feb 18-19) with makeup class scheduled for CS305.', '{"dates": {"start": "2026-02-18", "end": "2026-02-19"}, "reason": "Viral fever", "makeup_class": "CS305 next week"}', '2026-02-18 07:30:00'),
(8, 1, 4, 'Purchase 2 Additional Mobile Magnetic Whiteboards for Classrooms', 'Tutorial rooms AK-212 and AK-214 need magnetic rolling whiteboards for small group programming tutorials.', 'purchase', 'approved', 'medium', 2, 'Purchase request for 2 mobile magnetic whiteboards for tutorial rooms AK-212 and AK-214.', '{"category": "Furniture", "item": "Mobile Whiteboard 6x4", "quantity": 2, "estimated_cost": 90000, "rooms": ["AK-212", "AK-214"]}', '2026-02-22 13:10:00'),
(9, 1, 3, 'Annual JetBrains Educational Lab Licenses Renewal', 'Renewal of annual department-wide educational licenses for PyCharm, IntelliJ IDEA, and CLion for 150 student lab PCs.', 'purchase', 'approved', 'high', 2, 'Annual educational software license renewal request for JetBrains suite across 150 student lab seats.', '{"category": "Software", "vendor": "JetBrains", "seats": 150, "estimated_cost": 890000}', '2026-02-25 15:00:00'),
(10, 1, 5, 'Upgrade Network Switch in Robotics Lab AK-105', 'The current unmanaged switch in Robotics Lab AK-105 is dropping packets during ROS2 robot telemetry streaming. Requesting a 24-Port Gigabit managed PoE switch.', 'purchase', 'under_review', 'high', 2, 'Pending purchase request for 1 Gigabit PoE managed switch for Robotics Lab AK-105.', '{"category": "Networking", "item": "Gigabit PoE Switch 24-Port", "quantity": 1, "estimated_cost": 185000, "location": "Lab AK-105"}', '2026-03-01 10:15:00'),
(11, 1, 6, 'Casual Leave for Family Wedding in Lahore', 'Requesting 3 days leave from April 10 to April 12. Office hours and student queries will be handled via MS Teams.', 'leave', 'pending', 'low', 1, 'Personal leave request for 3 days (April 10-12) with online consultation on MS Teams.', '{"dates": {"start": "2026-04-10", "end": "2026-04-12"}, "type": "Casual Leave"}', '2026-03-02 11:00:00'),
(12, 1, 4, 'Biometric Attendance Scanner Malfunction at Faculty Entrance', 'The ZKTeco biometric thumb scanner at the CS faculty entrance is intermittently failing to record attendance stamps.', 'maintenance', 'under_review', 'urgent', 2, 'Urgent biometric attendance device maintenance at CS faculty entrance.', '{"location": "CS Faculty Entrance", "system": "ZKTeco Biometric Scanner"}', '2026-03-03 09:20:00'),
(13, 1, 3, 'Purchase 10 Raspberry Pi 5 Kits for Embedded Systems Course', 'Requesting 10 new Raspberry Pi 5 8GB units with camera and sensor kits for student IoT lab projects in CS490 track.', 'purchase', 'pending', 'medium', 2, 'Purchase request for 10 Raspberry Pi 5 kits for CS490 embedded systems labs.', '{"category": "Lab Equipment", "item": "Raspberry Pi 5 8GB Kit", "quantity": 10, "estimated_cost": 290000, "course": "CS490"}', '2026-03-04 14:40:00'),
(14, 1, 5, 'All-Pakistan Inter-University Hackathon 2026 Hosting Approval', 'Seeking formal approval and budget allocation for hosting the Annual All-Pakistan Inter-University Hackathon on April 25-26 in Al-Khawarizmi Complex.', 'general', 'approved', 'medium', 1, 'Event hosting proposal for All-Pakistan Inter-University Hackathon in Al-Khawarizmi Complex.', '{"event": "National Hackathon 2026", "dates": "2026-04-25 to 2026-04-26", "location": "Al-Khawarizmi Complex"}', '2026-03-05 16:00:00'),
(15, 1, 6, 'Defective HDMI Port in Seminar Room B', 'The podium HDMI socket in Seminar Room B is loose and causing signal dropouts to the wall displays during presentations.', 'maintenance', 'pending', 'low', 2, 'Minor maintenance request to repair podium HDMI wall port in Seminar Room B.', '{"location": "Seminar Room B", "issue": "Loose HDMI port pin"}', '2026-03-06 10:45:00'),
(16, 1, 4, 'Purchase 5 Mesh Office Chairs for Research Scholars Room', 'The existing chairs in PhD & MS Research Scholars Room AK-202 need replacement due to broken hydraulic cylinders.', 'purchase', 'pending', 'medium', 2, 'Purchase request for 5 mesh office chairs for Research Scholars workspace AK-202.', '{"category": "Furniture", "item": "Ergonomic Mesh Chair", "quantity": 5, "estimated_cost": 175000, "location": "Room AK-202"}', '2026-03-07 13:30:00'),
(17, 1, 3, 'Purchase 2 4K Color Grading Monitors for Digital Media Lab', 'Requesting 2 32-inch 4K HDR displays for student final year projects in VR/AR rendering.', 'purchase', 'returned', 'medium', 2, 'Purchase request returned for vendor quotation comparison and budget re-evaluation.', '{"category": "Computers", "item": "4K HDR Display 32-inch", "quantity": 2, "estimated_cost": 310000}', '2026-03-07 15:10:00'),
(18, 1, 5, 'HEC Travel Grant Application for ACM SIGMOD Presentation', 'Applying for departmental endorsement for HEC travel grant to present accepted research paper on distributed databases.', 'general', 'under_review', 'high', 1, 'Departmental endorsement request for HEC research travel grant for ACM SIGMOD.', '{"event": "ACM SIGMOD", "type": "HEC Travel Grant", "estimated_cost": 550000}', '2026-03-08 09:15:00'),
(19, 1, 4, 'Window Glass Repair in Faculty Office AK-309', 'Cracked glass pane on south window in Dr. Rimsha Ahmad''s office requires urgent safety replacement.', 'maintenance', 'approved', 'low', 2, 'Facility maintenance to replace cracked window pane in Office AK-309.', '{"location": "Room AK-309", "item": "South window glass"}', '2026-03-08 11:30:00'),
(20, 1, 6, 'Purchase 4 Heavy-Duty Spike Extension Boards for Hardware Lab', 'Need 4 industrial spike extension cords with surge protection for test benches in Hardware Lab AK-101.', 'purchase', 'approved', 'low', 2, 'Supply purchase for 4 heavy-duty surge extension cords for Hardware Lab AK-101.', '{"category": "Networking", "quantity": 4, "estimated_cost": 28000}', '2026-03-08 14:00:00'),
(21, 1, 3, 'Duty Leave for National Curriculum Revision Committee (NCRC - HEC Islamabad)', 'Requesting 2 days duty leave on March 20-21 to attend HEC National Curriculum Revision Committee session in Islamabad.', 'leave', 'approved', 'low', 1, 'Duty leave request for HEC Islamabad NCRC session on March 20-21.', '{"dates": {"start": "2026-03-20", "end": "2026-03-21"}, "purpose": "HEC NCRC Islamabad"}', '2026-03-09 08:30:00'),
(22, 1, 5, 'PTCL Dedicated Fiber Line Speed Fluctuation in CS Labs', 'Network latency on the backup PTCL fiber gateway has spiked above 250ms during student online coding assessments.', 'maintenance', 'pending', 'medium', 2, 'Technical request to coordinate with PTCL enterprise NOC for fiber line latency troubleshooting.', '{"location": "Server Room AK-01", "provider": "PTCL Fiber"}', '2026-03-09 10:00:00'),
(23, 1, 4, 'Order 100 Printed Student Welcome Badges & Lanyards', 'Orientation materials and student lanyards for incoming Fall 2026 freshman batch.', 'purchase', 'approved', 'low', 2, 'Purchase request for 100 branded departmental lanyards for freshman orientation.', '{"category": "Stationery", "quantity": 100, "estimated_cost": 45000}', '2026-03-09 11:45:00'),
(24, 1, 6, 'Cloud Sandbox GPU Credits for CS405 Distributed Learning', 'Requesting Rs. 420,000 cloud credits allocation for CS405 Distributed Machine Learning semester student projects.', 'purchase', 'under_review', 'high', 2, 'Cloud compute resource request for CS405 student project infrastructure.', '{"category": "Software", "provider": "Cloud Compute", "amount": 420000, "course": "CS405"}', '2026-03-09 15:20:00'),
(25, 1, 3, 'Auditorium 1 Sound System Wireless Collar Mic Battery Replacement', 'Ahuja wireless microphone in Auditorium 1 has drained rechargeable cells and requires fresh replacement pack.', 'maintenance', 'approved', 'high', 2, 'Audio maintenance for Auditorium 1 wireless microphone battery pack replacement.', '{"location": "Auditorium 1", "item": "Ahuja mic batteries"}', '2026-03-10 09:00:00'),
(26, 1, 5, 'Industry Guest Lecture: Tech Director at Systems Limited (Lahore)', 'Inviting Principal AI Architect from Systems Limited for a 2-hour seminar on Enterprise MLOps in CS401.', 'general', 'approved', 'medium', 1, 'Guest lecture approval request for Systems Limited industry speaker in CS401.', '{"course": "CS401", "speaker_affiliation": "Systems Limited", "format": "In-Person"}', '2026-03-10 11:15:00'),
(27, 1, 4, 'Purchase 2 Heavy-Duty Hand Trollies for Moving Lab Workstations', 'Department requires 2 heavy-duty rolling trollies for transporting desktop workstations and server units between floors.', 'purchase', 'approved', 'medium', 2, 'Purchase request for 2 heavy-duty transport trollies.', '{"category": "Furniture", "quantity": 2, "estimated_cost": 65000}', '2026-03-10 13:00:00'),
(28, 1, 6, 'Replacement 850W Power Supply for Server Node AK-03', 'Redundant 850W PSU on Server Node AK-03 tripped during power fluctuation and needs urgent replacement.', 'maintenance', 'under_review', 'high', 2, 'Hardware maintenance: Replace redundant 850W server power supply on Node AK-03.', '{"location": "Server Room AK-01", "hardware": "Node AK-03 850W PSU"}', '2026-03-10 14:30:00'),
(29, 1, 3, 'Leave Request for IEEE Computer Society Pakistan Section Executive Council', 'Requesting 2 days official duty leave on April 3-4 for IEEE Pakistan Section AGM in Islamabad.', 'leave', 'pending', 'medium', 1, 'Duty leave request for IEEE Pakistan Section AGM on April 3-4.', '{"dates": {"start": "2026-04-03", "end": "2026-04-04"}, "organization": "IEEE Pakistan"}', '2026-03-10 16:00:00'),
(30, 1, 5, 'Purchase Formlabs 3D Resin Tank & Filament Cartridges', 'Consumables replenishment for 3D printer in Robotics Lab AK-105 for student final year robotics prototypes.', 'purchase', 'pending', 'low', 2, '3D printing resin consumable purchase for student design projects.', '{"category": "Lab Equipment", "item": "3D Printer Resin", "estimated_cost": 85000}', '2026-03-11 08:45:00'),
(31, 1, 4, 'Replace LED Batten Light in Office AK-325', 'Overhead 40W LED batten light in Dr. Usman Farooq''s office has burnt out.', 'maintenance', 'approved', 'low', 2, 'Facility maintenance: Replace office LED tube light.', '{"location": "Room AK-325", "issue": "Burnt LED batten"}', '2026-03-11 09:30:00'),
(32, 1, 3, 'We need 5 new desktop computers for the AI laboratory.', 'We need 5 high-speed desktop computers with Core i7 processors, 32GB RAM, and RTX 4070 GPUs for the AI laboratory to support capstone research in Computer Vision and NLP.', 'purchase', 'pending', 'high', 2, 'Purchase request for 5 AI laboratory desktop workstations with RTX 4070 GPUs.', '{"category": "Computers", "item": "Desktop Computer", "quantity": 5, "purpose": "AI laboratory", "priority": "high", "estimated_cost": 2150000}', '2026-03-11 11:00:00');

-- -------------------------------------------------------------------
-- 10. REQUEST HISTORY
-- -------------------------------------------------------------------
INSERT INTO request_history (request_id, changed_by, old_status, new_status, remarks, created_at) VALUES
(1, 3, NULL, 'pending', 'Request submitted by Dr. Ayesha Khan', '2026-01-15 09:30:00'),
(1, 2, 'pending', 'under_review', 'Assigned to Syed Muhammad Ali for vendor quotation review', '2026-01-15 11:00:00'),
(1, 2, 'under_review', 'approved', 'Approved under Q1 Computing Hardware budget allocation.', '2026-01-16 14:00:00'),
(2, 5, NULL, 'pending', 'Leave request submitted by Dr. Rimsha Ahmad', '2026-01-20 14:15:00'),
(2, 1, 'pending', 'approved', 'Approved. Travel grant documentation verified by Dean office.', '2026-01-21 10:00:00'),
(3, 6, NULL, 'pending', 'Urgent maintenance ticket opened', '2026-02-01 10:00:00'),
(3, 2, 'pending', 'approved', 'Facilities dispatch team notified and AC repair completed.', '2026-02-01 14:30:00'),
(17, 3, NULL, 'pending', 'Submitted purchase request', '2026-03-07 15:10:00'),
(17, 2, 'pending', 'returned', 'Please review local Haier / Dell vendor options to optimize departmental expense.', '2026-03-08 09:30:00');

-- -------------------------------------------------------------------
-- 11. REQUEST COMMENTS
-- -------------------------------------------------------------------
INSERT INTO request_comments (request_id, user_id, comment, created_at) VALUES
(1, 2, 'Dell authorized partner confirmed quotation for Rs. 370,000 per unit with 3-year onsite warranty.', '2026-01-15 13:45:00'),
(1, 3, 'Confirmed. The specifications satisfy our PyTorch CUDA and deep learning laboratory requirements.', '2026-01-15 15:10:00'),
(17, 2, 'Standard Dell 4K monitors are available locally at Rs. 120,000 each. Let us discuss in the departmental purchase committee meeting.', '2026-03-08 09:35:00');

-- -------------------------------------------------------------------
-- 12. REVENUE (12 Realistic Pakistani Higher Ed Revenue Records in PKR)
-- -------------------------------------------------------------------
INSERT INTO revenue (id, department_id, source, amount, date, description) VALUES
(1, 1, 'University Tuition Allocation (Fall 2025)', 42500000.00, '2025-09-01', 'Biannual departmental tuition share disbursement from University Bursar Office.'),
(2, 1, 'HEC National Research Program (NRPU) Grant', 18200000.00, '2025-10-15', 'Phase 1 grant funding for Distributed Edge AI & Cyber Defense lab infrastructure.'),
(3, 1, 'Industry Tech Sponsorship - Systems Limited AI Lab', 9800000.00, '2025-11-10', 'Annual research sponsorship and naming rights for AI Innovation Lab.'),
(4, 1, 'Professional Executive Training (Cloud & DevOps)', 5200000.00, '2025-12-05', 'Corporate training workshop fees on Cloud Architecture & Kubernetes for telecom engineers.'),
(5, 1, 'University Tuition Allocation (Spring 2026)', 45000000.00, '2026-01-10', 'Spring semester departmental student fee and laboratory tuition allocation.'),
(6, 1, 'Ignite National Technology Innovation Fund Grant', 14000000.00, '2026-01-25', 'Autonomous Robotic Swarm Telemetry analysis R&D grant tranche.'),
(7, 1, 'CS Alumni Endowment Fund for Lab Modernization', 7000000.00, '2026-02-02', 'Private alumni contribution designated for undergraduate computing lab modernization.'),
(8, 1, 'Specialized GPU Cloud Compute Lab Rental Fees', 3500000.00, '2026-02-15', 'External corporate R&D compute rental and AI benchmark cluster time sharing.'),
(9, 1, 'Summer Coding Academy Registrations', 2750000.00, '2026-02-28', 'Advance registrations for High School Python & AI Summer Camp.'),
(10, 1, 'IEEE Pakistan Chapter Conference Sponsorship', 1850000.00, '2026-03-02', 'Institutional sponsorship and delegate registration proceeds from IEEE INMIC.'),
(11, 1, 'P@SHA Industrial Advisory Board Membership Fees', 5600000.00, '2026-03-05', 'Annual tier-1 corporate advisory board consortium fees from software houses.'),
(12, 1, 'Smart Agriculture Patent Commercialization Royalty', 3980000.00, '2026-03-08', 'Quarterly royalty distribution from university ORIC Technology Transfer Office.');

-- -------------------------------------------------------------------
-- 13. EXPENSES (24 Realistic Expense Transactions in PKR)
-- -------------------------------------------------------------------
INSERT INTO expenses (id, department_id, category, amount, date, description, related_request_id, inventory_id) VALUES
(1, 1, 'Equipment Purchase', 1850000.00, '2026-01-18', 'Purchased 5 Dell OptiPlex workstations for AI Lab expansion.', 1, 1),
(2, 1, 'Office Supplies', 210000.00, '2026-02-06', 'A4 copy paper and high-yield black toner cartridges for admin office.', 4, 22),
(3, 1, 'Maintenance & Repairs', 125000.00, '2026-02-02', 'Emergency Dawlance 4-Ton AC compressor capacitor repair in Lab AK-102.', 3, NULL),
(4, 1, 'Software Licenses', 890000.00, '2026-02-26', 'JetBrains All-Product Educational Lab License Renewal (150 seats).', 9, NULL),
(5, 1, 'Travel & Conferences', 420000.00, '2026-01-22', 'Travel grant and registration for Dr. Rimsha Ahmad at IEEE INMIC Karachi.', 2, NULL),
(6, 1, 'Furniture', 90000.00, '2026-02-24', '2 magnetic mobile rolling whiteboards for tutorial classrooms.', 8, 16),
(7, 1, 'Maintenance & Repairs', 75000.00, '2026-02-14', 'Replacement multimedia projector lamp for Lecture Hall AK-201.', 6, 5),
(8, 1, 'Cloud Services', 680000.00, '2025-10-01', 'Cloud compute sandbox infrastructure for student machine learning labs.', NULL, NULL),
(9, 1, 'Equipment Purchase', 6158000.00, '2025-11-20', '8 Apple MacBook Pro 16" laptops for tenure-track faculty.', NULL, 2),
(10, 1, 'Equipment Purchase', 5808000.00, '2025-09-10', '12 Lenovo ThinkPad P16 mobile engineering workstations.', NULL, 3),
(11, 1, 'Lab Equipment', 4366000.00, '2025-12-05', '6 NVIDIA RTX 4090 GPU deep learning accelerator units.', NULL, 4),
(12, 1, 'Networking Infrastructure', 4222000.00, '2025-04-10', 'Cisco Catalyst 9300 enterprise core networking switches.', NULL, 9),
(13, 1, 'Furniture', 1800000.00, '2025-01-15', '30 Master ergonomic faculty executive chairs.', NULL, 14),
(14, 1, 'Software Licenses', 1250000.00, '2025-08-25', 'MATLAB & Simulink Campus Departmental Site License.', NULL, NULL),
(15, 1, 'Software Licenses', 1720000.00, '2025-09-15', 'GitHub Enterprise Campus & OpenAI API research tier credits.', NULL, NULL),
(16, 1, 'Cloud Services', 1050000.00, '2026-01-05', 'Azure Cloud lab compute credits for Spring 2026 courses.', NULL, NULL),
(17, 1, 'Office Supplies', 275000.00, '2026-01-10', 'Dollar stationery, dry erase markers, and whiteboard supplies.', NULL, 20),
(18, 1, 'Events & Seminars', 980000.00, '2025-11-15', 'Catering and venue setup for Annual CS Industry Advisory Day.', NULL, NULL),
(19, 1, 'Lab Equipment', 1539000.00, '2025-02-14', 'Formlabs Form 3+ SLA 3D Printer for Robotics Lab.', NULL, 12),
(20, 1, 'Maintenance & Repairs', 240000.00, '2025-12-20', 'Annual UPS battery health inspection and recalibration in server room.', NULL, 18),
(21, 1, 'Networking Infrastructure', 920000.00, '2025-05-22', '15 Ubiquiti UniFi WiFi 6 access points across CS Wing.', NULL, 10),
(22, 1, 'Events & Seminars', 340000.00, '2026-03-06', 'Promotional banners, shields, and refreshments for National Hackathon.', 14, NULL),
(23, 1, 'Office Supplies', 45000.00, '2026-03-09', '100 CS orientation freshman welcome lanyards and folders.', 23, NULL),
(24, 1, 'Equipment Purchase', 65000.00, '2026-03-10', '2 heavy-duty equipment transport trollies.', 27, NULL);

-- -------------------------------------------------------------------
-- 14. BUDGETS (FY 2026 Departmental Budget in PKR)
-- -------------------------------------------------------------------
INSERT INTO budgets (id, department_id, period_name, allocated_amount, start_date, end_date) VALUES
(1, 1, 'FY 2025-26 Annual Operating Budget', 125000000.00, '2025-07-01', '2026-06-30'),
(2, 1, 'Spring 2026 CapEx Modernization Budget', 35000000.00, '2026-01-01', '2026-05-31');

-- -------------------------------------------------------------------
-- 15. REVENUE GOALS (in PKR)
-- -------------------------------------------------------------------
INSERT INTO revenue_goals (id, department_id, period_name, target_amount, start_date, end_date) VALUES
(1, 1, 'FY 2025-26 External Grants & Tuition Target', 160000000.00, '2025-07-01', '2026-06-30'),
(2, 1, 'Spring 2026 Research & Corporate Sponsorship', 65000000.00, '2026-01-01', '2026-05-31');

-- -------------------------------------------------------------------
-- 16. REPORTS (Sample Historical Metadata)
-- -------------------------------------------------------------------
INSERT INTO reports (id, department_id, title, report_type, reporting_period, generated_by, file_path, ai_summary) VALUES
(1, 1, 'Q1 Comprehensive Financial Health & Budget Variance Report', 'financial', 'FY26-Q1 (Jul 2025 - Sep 2025)', 1, 'uploads/reports/financial_q1_2026.pdf', 'Department operated at 82% of projected budget. Revenue exceeded quarterly benchmark by 14% driven by HEC research grants and corporate partnerships with Systems Limited.'),
(2, 1, 'Fall 2025 Academic Enrollment & Teaching Workload Audit', 'academic', 'Fall 2025', 1, 'uploads/reports/academic_fall_2025.pdf', 'Total enrollment reached 440 student-course seats. Average faculty teaching workload was 8.6 credit hours, well within the HEC 12-credit threshold.'),
(3, 1, 'Annual Department Inventory & Asset Depreciation Assessment', 'inventory', 'Annual 2025', 2, 'uploads/reports/inventory_annual_2025.pdf', 'Department manages Rs. 54.8 Million in physical computer, networking, and lab assets. 96.2% of equipment in Good/Fair operational condition.');
