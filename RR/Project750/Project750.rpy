I-Logix-RPY-Archive version 8.5.2 C++ 2030848
{ IProject 
	- _id = GUID 6a10f971-3493-4f9f-9892-5fc997543afd;
	- _myState = 8192;
	- _properties = { IPropertyContainer 
		- Subjects = { IRPYRawContainer 
			- size = 5;
			- value = 
			{ IPropertySubject 
				- _Name = "CG";
				- Metaclasses = { IRPYRawContainer 
					- size = 1;
					- value = 
					{ IPropertyMetaclass 
						- _Name = "CGGeneral";
						- Properties = { IRPYRawContainer 
							- size = 1;
							- value = 
							{ IProperty 
								- _Name = "GeneratedCodeInBrowser";
								- _Value = "True";
								- _Type = Bool;
							}
						}
					}
				}
			}
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
			{ IPropertySubject 
				- _Name = "General";
				- Metaclasses = { IRPYRawContainer 
					- size = 1;
					- value = 
					{ IPropertyMetaclass 
						- _Name = "Graphics";
						- Properties = { IRPYRawContainer 
							- size = 1;
							- value = 
							{ IProperty 
								- _Name = "StructureDiagramContext";
								- _Value = "Default";
								- _Type = Enum;
								- _ExtraTypeInfo = "Default,ClassOwner";
							}
						}
					}
				}
			}
			{ IPropertySubject 
				- _Name = "ObjectModelGe";
				- Metaclasses = { IRPYRawContainer 
					- size = 1;
					- value = 
					{ IPropertyMetaclass 
						- _Name = "Class";
						- Properties = { IRPYRawContainer 
							- size = 2;
							- value = 
							{ IProperty 
								- _Name = "ShowAttributes";
								- _Value = "All";
								- _Type = Enum;
								- _ExtraTypeInfo = "All,None,Public,Explicit";
							}
							{ IProperty 
								- _Name = "ShowOperations";
								- _Value = "All";
								- _Type = Enum;
								- _ExtraTypeInfo = "All,None,Public,Explicit";
							}
						}
					}
				}
			}
			{ IPropertySubject 
				- _Name = "SequenceDiagram";
				- Metaclasses = { IRPYRawContainer 
					- size = 1;
					- value = 
					{ IPropertyMetaclass 
						- _Name = "General";
						- Properties = { IRPYRawContainer 
							- size = 1;
							- value = 
							{ IProperty 
								- _Name = "ShowSequenceNumbers";
								- _Value = "True";
								- _Type = Bool;
							}
						}
					}
				}
			}
		}
	}
	- _name = "Project750";
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
	- _lastID = 4;
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
		- _id = GUID f98dfb49-bd36-4b14-9ea4-207018f7f7f3;
	}
	- _component = { IHandle 
		- _m2Class = "IComponent";
		- _filename = "Simulate.cmp";
		- _subsystem = "";
		- _class = "";
		- _name = "Simulate";
		- _id = GUID 13d23d66-33ef-42ca-8a0a-4bd8725e8191;
	}
	- Multiplicities = { IRPYRawContainer 
		- size = 4;
		- value = 
		{ IMultiplicityItem 
			- _name = "1";
			- _count = 32;
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
	}
	- Subsystems = { IRPYRawContainer 
		- size = 2;
		- value = 
		{ ISubsystem 
			- fileName = "Default";
			- _id = GUID f98dfb49-bd36-4b14-9ea4-207018f7f7f3;
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
	- Components = { IRPYRawContainer 
		- size = 1;
		- value = 
		{ IComponent 
			- fileName = "Simulate";
			- _id = GUID 13d23d66-33ef-42ca-8a0a-4bd8725e8191;
		}
	}
}

