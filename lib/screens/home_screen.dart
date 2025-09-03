import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_vet_app/screens/app_colors.dart';
import 'package:mobile_vet_app/screens/home_content.dart';
import 'profile_screen.dart';
import 'citas/citas_screen.dart';
import 'historia_screen.dart';
import 'lugares_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    //ProfileScreen(),
    HomeContent(),
    CitasScreen(),
    HistoriaScreen(),
    LugaresScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        items: [
          BottomNavigationBarItem(
            icon: _buildBottomNavItem(Icons.home, 0),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: _buildBottomNavItem(Icons.medical_services, 1),
            label: "Cita Medica",
          ),
          BottomNavigationBarItem(
            icon: _buildBottomNavItem(Icons.notifications_outlined, 2),
            label: "Notifications",
          ),
          BottomNavigationBarItem(
            icon: _buildBottomNavItem(Icons.account_circle_outlined, 3),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon, int index) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Icono
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(icon, size: 25)],
        ),
        // Rayita encima del icono si es el seleccionado
        if (_currentIndex == index)
          Positioned(
            left: 0,
            right: 0,
            bottom: 30, // Distancia de la rayita respecto al icono
            child: Container(
              height: 3,
              width:
                  MediaQuery.of(context).size.width /
                  8, // Ancho igual dividido entre 4 ítems
              color: AppColors.primary, // Color de la rayita
            ),
          ),
      ],
    );
  }
}
