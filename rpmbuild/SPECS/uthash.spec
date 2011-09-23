Name:           uthash
Version:        1.9.4
Release:        1%{?dist}
Summary:        Effective C-preprocessor implementation of Hash container for C

Group:          System Environment/Libraries
License:        MIT
URL:            http://uthash.sourceforge.net/
Source0:        http://downloads.sourceforge.net/project/uthash/uthash/uthash-1.9.4/%{name}-%{version}.tar.bz2
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)


%description
Any C structure can be stored in a hash table using uthash. Just add a UT_hash_handle to the structure and choose one or more fields in your structure to act as the key. Then use these macros to store, retrieve or delete items from the hash table.

%package        devel
Summary:        Development files for %{name}
Group:          Development/Libraries
Requires:       %{name} = %{version}-%{release}

%description    devel
The %{name}-devel package contains header files for
developing applications that use %{name}.

%prep
%setup -q

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT%{_includedir}/%{name}

cp src/*.h $RPM_BUILD_ROOT%{_includedir}/%{name}

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)

%files devel
%defattr(-,root,root,-)
%doc
%{_includedir}/%{name}/*.h

%changelog
* Tue Sep 20 2011 Vassili Leonov <vleo@linuxmedialabs.com>
- Initial RPM-isation by V.Leonov
