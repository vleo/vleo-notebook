I-Logix-RPY-Archive version 8.5.2 C 2030848
{ IProject 
	- _id = GUID ac4596b3-d013-4f28-93c5-94eabdac5c0f;
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
	- _name = "ProjectServer";
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
		- _id = GUID 1316b3ac-aeba-473d-84c0-e01ef9d196c3;
	}
	- _component = { IHandle 
		- _m2Class = "IComponent";
		- _filename = "DefaultComponent.cmp";
		- _subsystem = "";
		- _class = "";
		- _name = "DefaultComponent";
		- _id = GUID d950c5a1-ed7a-43da-81db-fd90fa7348ca;
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
		- size = 5;
		- value = 
		{ ISubsystem 
			- fileName = "Default";
			- _id = GUID 1316b3ac-aeba-473d-84c0-e01ef9d196c3;
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
		{ IProfile 
			- fileName = "CGCompatibilityPre753C";
			- _id = GUID e7e66be2-0250-451a-ae39-6f6ad5d6a5d2;
		}
	}
	- Diagrams = { IRPYRawContainer 
		- size = 1;
		- value = 
		{ IDiagram 
			- fileName = "Model1";
			- _id = GUID 4d0f1577-d591-4a69-93c7-2d7cc1f55159;
		}
	}
	- Components = { IRPYRawContainer 
		- size = 1;
		- value = 
		{ IComponent 
			- fileName = "DefaultComponent";
			- _id = GUID d950c5a1-ed7a-43da-81db-fd90fa7348ca;
		}
	}
}

