I-Logix-RPY-Archive version 8.5.2 C 1159120
{ IProject 
	- _id = GUID 848f1087-3c2d-47d3-97cc-54b6a9914d46;
	- _myState = 8192;
	- _properties = { IPropertyContainer 
		- Subjects = { IRPYRawContainer 
			- size = 1;
			- value = 
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
								- _Name = "DiagramIsSavedUnit";
								- _Value = "True";
								- _Type = Bool;
							}
						}
					}
				}
			}
		}
	}
	- _name = "ProjectClient";
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
		- _id = GUID 458c9734-3566-4dff-9210-f2c4cd221112;
	}
	- _component = { IHandle 
		- _m2Class = "IComponent";
		- _filename = "DefaultComponent.cmp";
		- _subsystem = "";
		- _class = "";
		- _name = "DefaultComponent";
		- _id = GUID e06c73df-abfb-41aa-8744-c52a2c33f8e3;
	}
	- Multiplicities = { IRPYRawContainer 
		- size = 4;
		- value = 
		{ IMultiplicityItem 
			- _name = "1";
			- _count = -1;
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
		- size = 4;
		- value = 
		{ ISubsystem 
			- fileName = "Default";
			- _id = GUID 458c9734-3566-4dff-9210-f2c4cd221112;
		}
		{ IProfile 
			- fileName = "CGCompatibilityPre72C";
			- _id = GUID 7b5e6f1d-ba31-4da4-8f5e-e123f8bd830d;
		}
		{ IProfile 
			- fileName = "CGCompatibilityPre73C";
			- _id = GUID 124c1307-9871-4403-816f-10b2719907f8;
		}
		{ IProfile 
			- fileName = "CGCompatibilityPre75C";
			- _id = GUID c31f72ca-ad02-4bd6-83c3-c4a04a0013ad;
		}
	}
	- Diagrams = { IRPYRawContainer 
		- size = 1;
		- value = 
		{ IDiagram 
			- fileName = "Model1";
			- _id = GUID 0ffbde0d-af62-4295-8c28-892a110082dd;
		}
	}
	- Components = { IRPYRawContainer 
		- size = 1;
		- value = 
		{ IComponent 
			- fileName = "DefaultComponent";
			- _id = GUID e06c73df-abfb-41aa-8744-c52a2c33f8e3;
		}
	}
}

