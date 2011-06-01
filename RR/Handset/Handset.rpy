I-Logix-RPY-Archive version 8.5.2 C++ 2030848
{ IProject 
	- _id = GUID 90a4bb6b-f529-4fef-8183-0a176ff1db32;
	- _myState = 8192;
	- _properties = { IPropertyContainer 
		- Subjects = { IRPYRawContainer 
			- size = 4;
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
			{ IPropertySubject 
				- _Name = "Format";
				- Metaclasses = { IRPYRawContainer 
					- size = 1;
					- value = 
					{ IPropertyMetaclass 
						- _Name = "Requirement";
						- Properties = { IRPYRawContainer 
							- size = 12;
							- value = 
							{ IProperty 
								- _Name = "DefaultSize";
								- _Value = "0,0,84,96";
								- _Type = String;
							}
							{ IProperty 
								- _Name = "Fill.FillColor";
								- _Value = "255,255,255";
								- _Type = Color;
							}
							{ IProperty 
								- _Name = "Font.Font";
								- _Value = "Arial";
								- _Type = String;
							}
							{ IProperty 
								- _Name = "Font.Font@Child.SpecificationTextCompartment";
								- _Value = "Arial";
								- _Type = String;
							}
							{ IProperty 
								- _Name = "Font.FontColor";
								- _Value = "0,0,0";
								- _Type = Color;
							}
							{ IProperty 
								- _Name = "Font.Italic@Child.SpecificationTextCompartment";
								- _Value = "0";
								- _Type = Int;
							}
							{ IProperty 
								- _Name = "Font.Size";
								- _Value = "10";
								- _Type = Int;
							}
							{ IProperty 
								- _Name = "Font.Size@Child.NameCompartment@Stereotype";
								- _Value = "8";
								- _Type = Int;
							}
							{ IProperty 
								- _Name = "Font.Size@Child.SpecificationTextCompartment";
								- _Value = "10";
								- _Type = Int;
							}
							{ IProperty 
								- _Name = "Font.Weight@Child.SpecificationTextCompartment";
								- _Value = "400";
								- _Type = Int;
							}
							{ IProperty 
								- _Name = "Line.LineColor";
								- _Value = "0,0,0";
								- _Type = Color;
							}
							{ IProperty 
								- _Name = "Line.LineWidth";
								- _Value = "1";
								- _Type = Int;
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
						- _Name = "Model";
						- Properties = { IRPYRawContainer 
							- size = 1;
							- value = 
							{ IProperty 
								- _Name = "BackUps";
								- _Value = "One";
								- _Type = Enum;
								- _ExtraTypeInfo = "None,One,Two";
							}
						}
					}
				}
			}
			{ IPropertySubject 
				- _Name = "UseCaseGe";
				- Metaclasses = { IRPYRawContainer 
					- size = 1;
					- value = 
					{ IPropertyMetaclass 
						- _Name = "Requirement";
						- Properties = { IRPYRawContainer 
							- size = 6;
							- value = 
							{ IProperty 
								- _Name = "Compartments";
								- _Value = "Specification,";
								- _Type = MultiLine;
							}
							{ IProperty 
								- _Name = "RequirementNotation";
								- _Value = "Box_Style";
								- _Type = Enum;
								- _ExtraTypeInfo = "Note_Style,Box_Style";
							}
							{ IProperty 
								- _Name = "ShowAnnotationContents";
								- _Value = "Description";
								- _Type = Enum;
								- _ExtraTypeInfo = "Name,Specification,Description,Label";
							}
							{ IProperty 
								- _Name = "ShowForm";
								- _Value = "Pushpin";
								- _Type = Enum;
								- _ExtraTypeInfo = "Plain,Note,Pushpin";
							}
							{ IProperty 
								- _Name = "ShowName";
								- _Value = "Name_only";
								- _Type = Enum;
								- _ExtraTypeInfo = "Full_path,Relative,Name_only,Label";
							}
							{ IProperty 
								- _Name = "ShowStereotype";
								- _Value = "Label";
								- _Type = Enum;
								- _ExtraTypeInfo = "Label,Bitmap,None";
							}
						}
					}
				}
			}
		}
	}
	- _name = "Handset";
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
	- _lastID = 3;
	- _UserColors = { IRPYRawContainer 
		- size = 16;
		- value = 16777215; 16777215; 16777215; 16777215; 16777215; 16777215; 16777215; 16777215; 16777215; 16777215; 16777215; 16777215; 16777215; 16777215; 16777215; 16777215; 
	}
	- _defaultSubsystem = { ISubsystemHandle 
		- _m2Class = "ISubsystem";
		- _filename = "HandsetRequirements.sbs";
		- _subsystem = "";
		- _class = "";
		- _name = "HandsetRequirements";
		- _id = GUID 6b13220e-e15a-4a25-9074-132de41d8d77;
	}
	- _component = { IHandle 
		- _m2Class = "IComponent";
		- _filename = "Simulation.cmp";
		- _subsystem = "";
		- _class = "";
		- _name = "Simulation";
		- _id = GUID 5c1eb796-587f-4e4b-9388-17438787b5da;
	}
	- Multiplicities = { IRPYRawContainer 
		- size = 4;
		- value = 
		{ IMultiplicityItem 
			- _name = "1";
			- _count = 18;
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
		- size = 7;
		- value = 
		{ ISubsystem 
			- fileName = "HandsetRequirements";
			- _id = GUID 6b13220e-e15a-4a25-9074-132de41d8d77;
		}
		{ IProfile 
			- fileName = "SysML";
			- _persistAs = "$OMROOT\\Profiles\\SysML\\SysMLProfile_rpy";
			- _id = GUID d9689b73-885e-44c4-896b-de43defa0a33;
			- _isReference = 1;
		}
		{ ISubsystem 
			- fileName = "Analysis";
			- _id = GUID a70d7c34-b032-4300-b799-77962af69560;
		}
		{ ISubsystem 
			- fileName = "Architecture";
			- _id = GUID cddd3ebe-3cd0-41c5-9318-a9ef2864be3b;
		}
		{ ISubsystem 
			- fileName = "Subsystems";
			- _id = GUID eb2914fd-8eef-48f2-9eae-39fecbafa2c6;
		}
		{ IProfile 
			- fileName = "CGCompatibilityPre751Cpp";
			- _id = GUID cb7b1c1a-b1ef-481f-9bc8-cb6d89a3848f;
		}
		{ IProfile 
			- fileName = "CGCompatibilityPre753Cpp";
			- _id = GUID 6d9087a8-4853-4759-a797-277df26481c2;
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
			- fileName = "Simulation";
			- _id = GUID 5c1eb796-587f-4e4b-9388-17438787b5da;
		}
	}
}

