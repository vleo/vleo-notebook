I-Logix-RPY-Archive version 8.5.2 C++ 2030848
{ IProject 
	- _id = GUID b5e44a9f-800f-4f41-aca7-ba00fb7dfebb;
	- _myState = 8192;
	- _properties = { IPropertyContainer 
		- Subjects = { IRPYRawContainer 
			- size = 1;
			- value = 
			{ IPropertySubject 
				- _Name = "CPP_CG";
				- Metaclasses = { IRPYRawContainer 
					- size = 1;
					- value = 
					{ IPropertyMetaclass 
						- _Name = "Configuration";
						- Properties = { IRPYRawContainer 
							- size = 1;
							- value = 
							{ IProperty 
								- _Name = "Environment";
								- _Value = "Cygwin";
								- _Type = Enum;
								- _ExtraTypeInfo = "Microsoft,MicrosoftDLL,MSVC9,MSVC9DLL,VxWorks,VxWorks6diab,VxWorks6gnu,VxWorks6diab_RTP,VxWorks6gnu_RTP,Solaris2,Cygwin,MultiWin32,Multi4Win32,MSStandardLibrary,MSVC9StandardLibrary,MicrosoftWinCE600,OseSfk,Linux,Solaris2GNU,QNXNeutrinoGCC, QNXNeutrinoMomentics,INTEGRITY,INTEGRITY5,IntegrityESTL,Integrity5ESTL,NucleusPLUS-PPC,WorkbenchManaged,WorkbenchManaged_RTP";
							}
						}
					}
				}
			}
		}
	}
	- _name = "brokerPattern";
	- Stereotypes = { IRPYRawContainer 
		- size = 1;
		- value = 
		{ IHandle 
			- _m2Class = "IStereotype";
			- _filename = "SysML.sbs";
			- _subsystem = "SysML";
			- _class = "";
			- _name = "SysML";
			- _id = GUID 052b8171-a32b-4f45-a829-5585f79f9deb;
		}
	}
	- _UserColors = { IRPYRawContainer 
		- size = 16;
		- value = 16777215; 16777215; 16777215; 16777215; 16777215; 16777215; 16777215; 16777215; 16777215; 16777215; 16777215; 16777215; 16777215; 16777215; 16777215; 16777215; 
	}
	- _defaultSubsystem = { ISubsystemHandle 
		- _m2Class = "ISubsystem";
		- _filename = "Default.sbs";
		- _subsystem = "";
		- _class = "";
		- _name = "Default";
		- _id = GUID fbb9a56d-c84e-4751-93b9-18af10885021;
	}
	- _component = { IHandle 
		- _m2Class = "IComponent";
		- _filename = "Simulate.cmp";
		- _subsystem = "";
		- _class = "";
		- _name = "Simulate";
		- _id = GUID 8023b372-8270-44cc-8f66-206100376e22;
	}
	- Multiplicities = { IRPYRawContainer 
		- size = 5;
		- value = 
		{ IMultiplicityItem 
			- _name = "1";
			- _count = 3;
		}
		{ IMultiplicityItem 
			- _name = "*";
			- _count = -1;
		}
		{ IMultiplicityItem 
			- _name = "0,1";
			- _count = -1;
		}
		{ IMultiplicityItem 
			- _name = "1..*";
			- _count = -1;
		}
		{ IMultiplicityItem 
			- _name = "2";
			- _count = 2;
		}
	}
	- Subsystems = { IRPYRawContainer 
		- size = 2;
		- value = 
		{ ISubsystem 
			- fileName = "Default";
			- _id = GUID fbb9a56d-c84e-4751-93b9-18af10885021;
		}
		{ IProfile 
			- fileName = "SysML";
			- _persistAs = "$OMROOT\\Profiles\\SysML\\SysMLProfile_rpy";
			- _id = GUID d9689b73-885e-44c4-896b-de43defa0a33;
			- _isReference = 1;
		}
	}
	- Diagrams = { IRPYRawContainer 
		- size = 0;
	}
	- MSCS = { IRPYRawContainer 
		- size = 0;
	}
	- Components = { IRPYRawContainer 
		- size = 1;
		- value = 
		{ IComponent 
			- fileName = "Simulate";
			- _id = GUID 8023b372-8270-44cc-8f66-206100376e22;
		}
	}
}

