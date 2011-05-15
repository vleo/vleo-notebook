I-Logix-RPY-Archive version 8.5.2 C++ 1164537
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
		- _filename = "DefaultComponent.cmp";
		- _subsystem = "";
		- _class = "";
		- _name = "DefaultComponent";
		- _id = GUID 5c1eb796-587f-4e4b-9388-17438787b5da;
	}
	- Multiplicities = { IRPYRawContainer 
		- size = 4;
		- value = 
		{ IMultiplicityItem 
			- _name = "1";
			- _count = 1;
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
		- size = 5;
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
	}
	- Diagrams = { IRPYRawContainer 
		- size = 1;
		- value = 
		{ IStructureDiagram 
			- _id = GUID 240036a7-c9a6-4064-9b21-85d00a9cb103;
			- _myState = 8192;
			- _properties = { IPropertyContainer 
				- Subjects = { IRPYRawContainer 
					- size = 1;
					- value = 
					{ IPropertySubject 
						- _Name = "Format";
						- Metaclasses = { IRPYRawContainer 
							- size = 3;
							- value = 
							{ IPropertyMetaclass 
								- _Name = "DiagramFrame";
								- Properties = { IRPYRawContainer 
									- size = 9;
									- value = 
									{ IProperty 
										- _Name = "DefaultSize";
										- _Value = "20,20,590,500";
										- _Type = String;
									}
									{ IProperty 
										- _Name = "Fill.FillColor";
										- _Value = "255,255,255";
										- _Type = Color;
									}
									{ IProperty 
										- _Name = "Fill.Transparent_Fill";
										- _Value = "1";
										- _Type = Int;
									}
									{ IProperty 
										- _Name = "Font.Font";
										- _Value = "Arial";
										- _Type = String;
									}
									{ IProperty 
										- _Name = "Font.FontColor";
										- _Value = "0,0,255";
										- _Type = Color;
									}
									{ IProperty 
										- _Name = "Font.FontColor@Label.Stereotype";
										- _Value = "0,0,255";
										- _Type = Color;
									}
									{ IProperty 
										- _Name = "Font.Size";
										- _Value = "10";
										- _Type = Int;
									}
									{ IProperty 
										- _Name = "Line.LineColor";
										- _Value = "0,0,255";
										- _Type = Color;
									}
									{ IProperty 
										- _Name = "Line.LineWidth";
										- _Value = "1";
										- _Type = Int;
									}
								}
							}
							{ IPropertyMetaclass 
								- _Name = "FreeText";
								- Properties = { IRPYRawContainer 
									- size = 9;
									- value = 
									{ IProperty 
										- _Name = "Fill.Transparent_Fill";
										- _Value = "1";
										- _Type = Int;
									}
									{ IProperty 
										- _Name = "Font.Font";
										- _Value = "Arial";
										- _Type = String;
									}
									{ IProperty 
										- _Name = "Font.Height";
										- _Value = "13";
										- _Type = Int;
									}
									{ IProperty 
										- _Name = "Font.Size";
										- _Value = "10";
										- _Type = Int;
									}
									{ IProperty 
										- _Name = "HorzAlign";
										- _Value = "0";
										- _Type = Int;
									}
									{ IProperty 
										- _Name = "Line.Transparent";
										- _Value = "1";
										- _Type = Int;
									}
									{ IProperty 
										- _Name = "Multiline";
										- _Value = "True";
										- _Type = Bool;
									}
									{ IProperty 
										- _Name = "VertAlign";
										- _Value = "0";
										- _Type = Int;
									}
									{ IProperty 
										- _Name = "Wordbreak";
										- _Value = "False";
										- _Type = Bool;
									}
								}
							}
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
				}
			}
			- _name = "Structure1";
			- Stereotypes = { IRPYRawContainer 
				- size = 1;
				- value = 
				{ IHandle 
					- _m2Class = "IStereotype";
					- _filename = "SysML.sbs";
					- _subsystem = "SysML::Diagrams";
					- _class = "";
					- _name = "Internal Block Diagram";
					- _id = GUID 38dfec39-1968-4f0a-87ef-c2fde9a5d5e1;
				}
			}
			- _lastModifiedTime = "5.15.2011::19:36:19";
			- _graphicChart = { CGIClassChart 
				- _id = GUID 66bb39b7-5f5e-4dbd-af26-4bfc9a13769d;
				- m_type = 0;
				- m_pModelObject = { IHandle 
					- _m2Class = "IStructureDiagram";
					- _id = GUID 240036a7-c9a6-4064-9b21-85d00a9cb103;
				}
				- m_pParent = ;
				- m_name = { CGIText 
					- m_str = "";
					- m_style = "Arial" 10 0 0 0 1 ;
					- m_color = { IColor 
						- m_fgColor = 0;
						- m_bgColor = 0;
						- m_bgFlag = 0;
					}
					- m_position = 1 0 0  ;
					- m_nIdent = 0;
					- m_bImplicitSetRectPoints = 0;
					- m_nOrientationCtrlPt = 8;
				}
				- m_drawBehavior = 0;
				- m_bIsPreferencesInitialized = 0;
				- elementList = 3;
				{ CGIClass 
					- _id = GUID 278fe39d-904f-4fa4-b1aa-6ad36f31a9cd;
					- m_type = 78;
					- m_pModelObject = { IHandle 
						- _m2Class = "IClass";
						- _filename = "HandsetRequirements.sbs";
						- _subsystem = "HandsetRequirements";
						- _class = "";
						- _name = "TopLevel";
						- _id = GUID b8ee7ea5-4796-490d-b1c8-e02945c44b75;
					}
					- m_pParent = ;
					- m_name = { CGIText 
						- m_str = "TopLevel";
						- m_style = "Arial" 10 0 0 0 1 ;
						- m_color = { IColor 
							- m_fgColor = 0;
							- m_bgColor = 0;
							- m_bgFlag = 0;
						}
						- m_position = 1 0 0  ;
						- m_nIdent = 0;
						- m_bImplicitSetRectPoints = 0;
						- m_nOrientationCtrlPt = 5;
					}
					- m_drawBehavior = 0;
					- m_bIsPreferencesInitialized = 0;
					- m_AdditionalLabel = { CGIText 
						- m_str = "";
						- m_style = "Arial" 10 0 0 0 1 ;
						- m_color = { IColor 
							- m_fgColor = 0;
							- m_bgColor = 0;
							- m_bgFlag = 0;
						}
						- m_position = 1 0 0  ;
						- m_nIdent = 0;
						- m_bImplicitSetRectPoints = 0;
						- m_nOrientationCtrlPt = 1;
					}
					- m_polygon = 0 ;
					- m_nNameFormat = 0;
					- m_nIsNameFormat = 0;
					- Attrs = { IRPYRawContainer 
						- size = 0;
					}
					- Operations = { IRPYRawContainer 
						- size = 0;
					}
				}
				{ CGIDiagramFrame 
					- _id = GUID 958d6c93-32b4-4ccd-8e65-69b48d4936ff;
					- m_type = 203;
					- m_pModelObject = { IHandle 
						- _m2Class = "";
					}
					- m_pParent = GUID 278fe39d-904f-4fa4-b1aa-6ad36f31a9cd;
					- m_name = { CGIText 
						- m_str = "";
						- m_style = "Arial" 10 0 0 0 1 ;
						- m_color = { IColor 
							- m_fgColor = 0;
							- m_bgColor = 0;
							- m_bgFlag = 0;
						}
						- m_position = 1 0 0  ;
						- m_nIdent = 0;
						- m_bImplicitSetRectPoints = 0;
						- m_nOrientationCtrlPt = 8;
					}
					- m_drawBehavior = 4096;
					- m_transform = 2.63889 0 0 3.63636 20 20 ;
					- m_bIsPreferencesInitialized = 1;
					- m_AdditionalLabel = { CGIText 
						- m_str = "";
						- m_style = "Arial" 10 0 0 0 1 ;
						- m_color = { IColor 
							- m_fgColor = 0;
							- m_bgColor = 0;
							- m_bgFlag = 0;
						}
						- m_position = 1 0 0  ;
						- m_nIdent = 0;
						- m_bImplicitSetRectPoints = 0;
						- m_nOrientationCtrlPt = 1;
					}
					- m_polygon = 4 0 0  0 132  216 132  216 0  ;
					- m_nNameFormat = 0;
					- m_nIsNameFormat = 0;
				}
				{ CGIFreeText 
					- _id = GUID d352a02a-b884-43a0-b3c6-d8bc195f5ebb;
					- m_type = 189;
					- m_pModelObject = { IHandle 
						- _m2Class = "";
					}
					- m_pParent = GUID 278fe39d-904f-4fa4-b1aa-6ad36f31a9cd;
					- m_name = { CGIText 
						- m_str = "";
						- m_style = "Arial" 10 0 0 0 1 ;
						- m_color = { IColor 
							- m_fgColor = 0;
							- m_bgColor = 0;
							- m_bgFlag = 0;
						}
						- m_position = 1 0 0  ;
						- m_nIdent = 0;
						- m_bImplicitSetRectPoints = 0;
						- m_nOrientationCtrlPt = 8;
					}
					- m_drawBehavior = 4096;
					- m_transform = 1 0 0 1 -59 -3 ;
					- m_bIsPreferencesInitialized = 1;
					- m_points = 4 603 15  644 15  644 33  603 33  ;
					- m_text = "Block Diagram";
				}
				
				- m_access = 'Z';
				- m_modified = 'N';
				- m_fileVersion = "";
				- m_nModifyDate = 0;
				- m_nCreateDate = 0;
				- m_creator = "";
				- m_bScaleWithZoom = 1;
				- m_arrowStyle = 'S';
				- m_pRoot = GUID 278fe39d-904f-4fa4-b1aa-6ad36f31a9cd;
				- m_currentLeftTop = 0 0 ;
				- m_currentRightBottom = 0 0 ;
			}
			- _defaultSubsystem = { IHandle 
				- _m2Class = "ISubsystem";
				- _filename = "HandsetRequirements.sbs";
				- _subsystem = "";
				- _class = "";
				- _name = "HandsetRequirements";
				- _id = GUID 6b13220e-e15a-4a25-9074-132de41d8d77;
			}
		}
	}
	- Components = { IRPYRawContainer 
		- size = 1;
		- value = 
		{ IComponent 
			- fileName = "DefaultComponent";
			- _id = GUID 5c1eb796-587f-4e4b-9388-17438787b5da;
		}
	}
}

