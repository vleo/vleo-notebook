// Protocol Buffers - Google's data interchange format
// Copyright 2008 Google Inc.
// http://code.google.com/p/protobuf/
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package com.google.protobuf;

import com.google.protobuf.DescriptorProtos.*;

import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Contains a collection of classes which describe protocol message types.
 *
 * Every message type has a {@link Descriptors.Descriptor}, which lists all
 * its fields and other information about a type.  You can get a message
 * type's descriptor by calling {@code MessageType.getDescriptor()}, or
 * (given a message object of the type) {@code message.getDescriptorForType()}.
 *
 * Descriptors are built from DescriptorProtos, as defined in
 * {@code net/proto2/proto/descriptor.proto}.
 *
 * @author kenton@google.com Kenton Varda
 */
public final class Descriptors {
  /**
   * Describes a {@code .proto} file, including everything defined within.
   */
  public static final class FileDescriptor {
    /** Convert the descriptor to its protocol message representation. */
    public FileDescriptorProto toProto() { return proto; }

    /** Get the file name. */
    public String getName() { return proto.getName(); }

    /**
     * Get the proto package name.  This is the package name given by the
     * {@code package} statement in the {@code .proto} file, which differs
     * from the Java package.
     */
    public String getPackage() { return proto.getPackage(); }

    /** Get the {@code FileOptions}, defined in {@code descriptor.proto}. */
    public FileOptions getOptions() { return proto.getOptions(); }

    /** Get a list of top-level message types declared in this file. */
    public List<Descriptor> getMessageTypes() {
      return Collections.unmodifiableList(Arrays.asList(messageTypes));
    }

    /** Get a list of top-level enum types declared in this file. */
    public List<EnumDescriptor> getEnumTypes() {
      return Collections.unmodifiableList(Arrays.asList(enumTypes));
    }

    /** Get a list of top-level services declared in this file. */
    public List<ServiceDescriptor> getServices() {
      return Collections.unmodifiableList(Arrays.asList(services));
    }

    /** Get a list of top-level extensions declared in this file. */
    public List<FieldDescriptor> getExtensions() {
      return Collections.unmodifiableList(Arrays.asList(extensions));
    }

    /** Get a list of this file's dependencies (imports). */
    public List<FileDescriptor> getDependencies() {
      return Collections.unmodifiableList(Arrays.asList(dependencies));
    }

    /**
     * Find a message type in the file by name.  Does not find nested types.
     *
     * @param name The unqualified type name to look for.
     * @return The message type's descriptor, or {@code null} if not found.
     */
    public Descriptor findMessageTypeByName(String name) {
      // Don't allow looking up nested types.  This will make optimization
      // easier later.
      if (name.indexOf('.') != -1) return null;
      if (getPackage().length() > 0) {
        name = getPackage() + "." + name;
      }
      GenericDescriptor result = pool.findSymbol(name);
      if (result != null && result instanceof Descriptor &&
          result.getFile() == this) {
        return (Descriptor)result;
      } else {
        return null;
      }
    }

    /**
     * Find an enum type in the file by name.  Does not find nested types.
     *
     * @param name The unqualified type name to look for.
     * @return The enum type's descriptor, or {@code null} if not found.
     */
    public EnumDescriptor findEnumTypeByName(String name) {
      // Don't allow looking up nested types.  This will make optimization
      // easier later.
      if (name.indexOf('.') != -1) return null;
      if (getPackage().length() > 0) {
        name = getPackage() + "." + name;
      }
      GenericDescriptor result = pool.findSymbol(name);
      if (result != null && result instanceof EnumDescriptor &&
          result.getFile() == this) {
        return (EnumDescriptor)result;
      } else {
        return null;
      }
    }

    /**
     * Find a service type in the file by name.
     *
     * @param name The unqualified type name to look for.
     * @return The service type's descriptor, or {@code null} if not found.
     */
    public ServiceDescriptor findServiceByName(String name) {
      // Don't allow looking up nested types.  This will make optimization
      // easier later.
      if (name.indexOf('.') != -1) return null;
      if (getPackage().length() > 0) {
        name = getPackage() + "." + name;
      }
      GenericDescriptor result = pool.findSymbol(name);
      if (result != null && result instanceof ServiceDescriptor &&
          result.getFile() == this) {
        return (ServiceDescriptor)result;
      } else {
        return null;
      }
    }

    /**
     * Find an extension in the file by name.  Does not find extensions nested
     * inside message types.
     *
     * @param name The unqualified extension name to look for.
     * @return The extension's descriptor, or {@code null} if not found.
     */
    public FieldDescriptor findExtensionByName(String name) {
      if (name.indexOf('.') != -1) return null;
      if (getPackage().length() > 0) {
        name = getPackage() + "." + name;
      }
      GenericDescriptor result = pool.findSymbol(name);
      if (result != null && result instanceof FieldDescriptor &&
          result.getFile() == this) {
        return (FieldDescriptor)result;
      } else {
        return null;
      }
    }

    /**
     * Construct a {@code FileDescriptor}.
     *
     * @param proto The protocol message form of the FileDescriptor.
     * @param dependencies {@code FileDescriptor}s corresponding to all of
     *                     the file's dependencies, in the exact order listed
     *                     in {@code proto}.
     * @throws DescriptorValidationException {@code proto} is not a valid
     *           descriptor.  This can occur for a number of reasons, e.g.
     *           because a field has an undefined type or because two messages
     *           were defined with the same name.
     */
    public static FileDescriptor buildFrom(FileDescriptorProto proto,
                                           FileDescriptor[] dependencies)
                                    throws DescriptorValidationException {
      // Building decsriptors involves two steps:  translating and linking.
      // In the translation step (implemented by FileDescriptor's
      // constructor), we build an object tree mirroring the
      // FileDescriptorProto's tree and put all of the descriptors into the
      // DescriptorPool's lookup tables.  In the linking step, we look up all
      // type references in the DescriptorPool, so that, for example, a
      // FieldDescriptor for an embedded message contains a pointer directly
      // to the Descriptor for that message's type.  We also detect undefined
      // types in the linking step.
      DescriptorPool pool = new DescriptorPool(dependencies);
      FileDescriptor result = new FileDescriptor(proto, dependencies, pool);

      if (dependencies.length != proto.getDependencyCount()) {
        throw new DescriptorValidationException(result,
          "Dependencies passed to FileDescriptor.buildFrom() don't match " +
          "those listed in the FileDescriptorProto.");
      }
      for (int i = 0; i < proto.getDependencyCount(); i++) {
        if (!dependencies[i].getName().equals(proto.getDependency(i))) {
          throw new DescriptorValidationException(result,
            "Dependencies passed to FileDescriptor.buildFrom() don't match " +
            "those listed in the FileDescriptorProto.");
        }
      }

      result.crossLink();
      return result;
    }

    /**
     * This method is to be called by generated code only.  It is equivalent
     * to {@code buildFrom} except that the {@code FileDescriptorProto} is
     * encoded in protocol buffer wire format.
     */
    public static FileDescriptor internalBuildGeneratedFileFrom(
        String descriptorData, FileDescriptor[] dependencies)
        throws DescriptorValidationException,
               InvalidProtocolBufferException {
      // Hack:  We can't embed a raw byte array inside generated Java code
      //   (at least, not efficiently), but we can embed Strings.  So, the
      //   protocol compiler embeds the FileDescriptorProto as a giant
      //   string literal which is passed to this function to construct the
      //   file's FileDescriptor.  The string literal contains only 8-bit
      //   characters, each one representing a byte of the FileDescriptorProto's
      //   serialized form.  So, if we convert it to bytes in ISO-8859-1, we
      //   should get the original bytes that we want.
      try {
        FileDescriptorProto proto =
          FileDescriptorProto.parseFrom(descriptorData.getBytes("ISO-8859-1"));
        return buildFrom(proto, dependencies);
      } catch (java.io.UnsupportedEncodingException e) {
        throw new RuntimeException(
          "Standard encoding ISO-8859-1 not supported by JVM.", e);
      }
    }

    private final FileDescriptorProto proto;
    private final Descriptor[] messageTypes;
    private final EnumDescriptor[] enumTypes;
    private final ServiceDescriptor[] services;
    private final FieldDescriptor[] extensions;
    private final FileDescriptor[] dependencies;
    private final DescriptorPool pool;

    private FileDescriptor(FileDescriptorProto proto,
                           FileDescriptor[] dependencies,
                           DescriptorPool pool)
                    throws DescriptorValidationException {
      this.pool = pool;
      this.proto = proto;
      this.dependencies = dependencies.clone();

      pool.addPackage(getPackage(), this);

      messageTypes = new Descriptor[proto.getMessageTypeCount()];
      for (int i = 0; i < proto.getMessageTypeCount(); i++) {
        messageTypes[i] =
          new Descriptor(proto.getMessageType(i), this, null, i);
      }

      enumTypes = new EnumDescriptor[proto.getEnumTypeCount()];
      for (int i = 0; i < proto.getEnumTypeCount(); i++) {
        enumTypes[i] = new EnumDescriptor(proto.getEnumType(i), this, null, i);
      }

      services = new ServiceDescriptor[proto.getServiceCount()];
      for (int i = 0; i < proto.getServiceCount(); i++) {
        services[i] = new ServiceDescriptor(proto.getService(i), this, i);
      }

      extensions = new FieldDescriptor[proto.getExtensionCount()];
      for (int i = 0; i < proto.getExtensionCount(); i++) {
        extensions[i] = new FieldDescriptor(
          proto.getExtension(i), this, null, i, true);
      }
    }

    /** Look up and cross-link all field types, etc. */
    private void crossLink() throws DescriptorValidationException {
      for (int i = 0; i < messageTypes.length; i++) {
        messageTypes[i].crossLink();
      }

      for (int i = 0; i < services.length; i++) {
        services[i].crossLink();
      }

      for (int i = 0; i < extensions.length; i++) {
        extensions[i].crossLink();
      }
    }
  }

  // =================================================================

  /** Describes a message type. */
  public static final class Descriptor implements GenericDescriptor {
    /**
     * Get the index of this descriptor within its parent.  In other words,
     * given a {@link FileDescriptor} {@code file}, the following is true:
     * <pre>
     *   for all i in [0, file.getMessageTypeCount()):
     *     file.getMessageType(i).getIndex() == i
     * </pre>
     * Similarly, for a {@link Descriptor} {@code messageType}:
     * <pre>
     *   for all i in [0, messageType.getNestedTypeCount()):
     *     messageType.getNestedType(i).getIndex() == i
     * </pre>
     */
    public int getIndex() { return index; }

    /** Convert the descriptor to its protocol message representation. */
    public DescriptorProto toProto() { return proto; }

    /** Get the type's unqualified name. */
    public String getName() { return proto.getName(); }

    /**
     * Get the type's fully-qualified name, within the proto language's
     * namespace.  This differs from the Java name.  For example, given this
     * {@code .proto}:
     * <pre>
     *   package foo.bar;
     *   option java_package = "com.example.protos"
     *   message Baz {}
     * </pre>
     * {@code Baz}'s full name is "foo.bar.Baz".
     */
    public String getFullName() { return fullName; }

    /** Get the {@link FileDescriptor} containing this descriptor. */
    public FileDescriptor getFile() { return file; }

    /** If this is a nested type, get the outer descriptor, otherwise null. */
    public Descriptor getContainingType() { return containingType; }

    /** Get the {@code MessageOptions}, defined in {@code descriptor.proto}. */
    public MessageOptions getOptions() { return proto.getOptions(); }

    /** Get a list of this message type's fields. */
    public List<FieldDescriptor> getFields() {
      return Collections.unmodifiableList(Arrays.asList(fields));
    }

    /** Get a list of this message type's extensions. */
    public List<FieldDescriptor> getExtensions() {
      return Collections.unmodifiableList(Arrays.asList(extensions));
    }

    /** Get a list of message types nested within this one. */
    public List<Descriptor> getNestedTypes() {
      return Collections.unmodifiableList(Arrays.asList(nestedTypes));
    }

    /** Get a list of enum types nested within this one. */
    public List<EnumDescriptor> getEnumTypes() {
      return Collections.unmodifiableList(Arrays.asList(enumTypes));
    }

    /** Determines if the given field number is an extension. */
    public boolean isExtensionNumber(int number) {
      for (DescriptorProto.ExtensionRange range : proto.getExtensionRangeList()) {
        if (range.getStart() <= number && number < range.getEnd()) {
          return true;
        }
      }
      return false;
    }

    /**
     * Finds a field by name.
     * @param name The unqualified name of the field (e.g. "foo").
     * @return The field's descriptor, or {@code null} if not found.
     */
    public FieldDescriptor findFieldByName(String name) {
      GenericDescriptor result = file.pool.findSymbol(fullName + "." + name);
      if (result != null && result instanceof FieldDescriptor) {
        return (FieldDescriptor)result;
      } else {
        return null;
      }
    }

    /**
     * Finds a field by field number.
     * @param number The field number within this message type.
     * @return The field's descriptor, or {@code null} if not found.
     */
    public FieldDescriptor findFieldByNumber(int number) {
      return file.pool.fieldsByNumber.get(
        new DescriptorPool.DescriptorIntPair(this, number));
    }

    /**
     * Finds a nested message type by name.
     * @param name The unqualified name of the nested type (e.g. "Foo").
     * @return The types's descriptor, or {@code null} if not found.
     */
    public Descriptor findNestedTypeByName(String name) {
      GenericDescriptor result = file.pool.findSymbol(fullName + "." + name);
      if (result != null && result instanceof Descriptor) {
        return (Descriptor)result;
      } else {
        return null;
      }
    }

    /**
     * Finds a nested enum type by name.
     * @param name The unqualified name of the nested type (e.g. "Foo").
     * @return The types's descriptor, or {@code null} if not found.
     */
    public EnumDescriptor findEnumTypeByName(String name) {
      GenericDescriptor result = file.pool.findSymbol(fullName + "." + name);
      if (result != null && result instanceof EnumDescriptor) {
        return (EnumDescriptor)result;
      } else {
        return null;
      }
    }

    private final int index;
    private final DescriptorProto proto;
    private final String fullName;
    private final FileDescriptor file;
    private final Descriptor containingType;
    private final Descriptor[] nestedTypes;
    private final EnumDescriptor[] enumTypes;
    private final FieldDescriptor[] fields;
    private final FieldDescriptor[] extensions;

    private Descriptor(DescriptorProto proto,
                       FileDescriptor file,
                       Descriptor parent,
                       int index)
                throws DescriptorValidationException {
      this.index = index;
      this.proto = proto;
      this.fullName = computeFullName(file, parent, proto.getName());
      this.file = file;
      this.containingType = parent;

      this.nestedTypes = new Descriptor[proto.getNestedTypeCount()];
      for (int i = 0; i < proto.getNestedTypeCount(); i++) {
        this.nestedTypes[i] = new Descriptor(
          proto.getNestedType(i), file, this, i);
      }

      this.enumTypes = new EnumDescriptor[proto.getEnumTypeCount()];
      for (int i = 0; i < proto.getEnumTypeCount(); i++) {
        this.enumTypes[i] = new EnumDescriptor(
          proto.getEnumType(i), file, this, i);
      }

      this.fields = new FieldDescriptor[proto.getFieldCount()];
      for (int i = 0; i < proto.getFieldCount(); i++) {
        this.fields[i] = new FieldDescriptor(
          proto.getField(i), file, this, i, false);
      }

      this.extensions = new FieldDescriptor[proto.getExtensionCount()];
      for (int i = 0; i < proto.getExtensionCount(); i++) {
        this.extensions[i] = new FieldDescriptor(
          proto.getExtension(i), file, this, i, true);
      }

      file.pool.addSymbol(this);
    }

    /** Look up and cross-link all field types, etc. */
    private void crossLink() throws DescriptorValidationException {
      for (int i = 0; i < nestedTypes.length; i++) {
        nestedTypes[i].crossLink();
      }

      for (int i = 0; i < fields.length; i++) {
        fields[i].crossLink();
      }

      for (int i = 0; i < extensions.length; i++) {
        extensions[i].crossLink();
      }
    }
  }

  // =================================================================

  /** Describes a field of a message type. */
  public static final class FieldDescriptor
      implements GenericDescriptor, Comparable<FieldDescriptor> {
    /**
     * Get the index of this descriptor within its parent.
     * @see Descriptors.Descriptor#getIndex()
     */
    public int getIndex() { return index; }

    /** Convert the descriptor to its protocol message representation. */
    public FieldDescriptorProto toProto() { return proto; }

    /** Get the field's unqualified name. */
    public String getName() { return proto.getName(); }

    /** Get the field's number. */
    public int getNumber() { return proto.getNumber(); }

    /**
     * Get the field's fully-qualified name.
     * @see Descriptors.Descriptor#getFullName()
     */
    public String getFullName() { return fullName; }

    /**
     * Get the field's java type.  This is just for convenience.  Every
     * {@code FieldDescriptorProto.Type} maps to exactly one Java type.
     */
    public JavaType getJavaType() { return type.getJavaType(); }

    /** Get the {@code FileDescriptor} containing this descriptor. */
    public FileDescriptor getFile() { return file; }

    /** Get the field's declared type. */
    public Type getType() { return type; }

    /** Is this field declared required? */
    public boolean isRequired() {
      return proto.getLabel() == FieldDescriptorProto.Label.LABEL_REQUIRED;
    }

    /** Is this field declared optional? */
    public boolean isOptional() {
      return proto.getLabel() == FieldDescriptorProto.Label.LABEL_OPTIONAL;
    }

    /** Is this field declared repeated? */
    public boolean isRepeated() {
      return proto.getLabel() == FieldDescriptorProto.Label.LABEL_REPEATED;
    }

    /** Returns true if the field had an explicitly-defined default value. */
    public boolean hasDefaultValue() { return proto.hasDefaultValue(); }

    /**
     * Returns the field's default value.  Valid for all types except for
     * messages and groups.  For all other types, the object returned is of
     * the same class that would returned by Message.getField(this).
     */
    public Object getDefaultValue() {
      if (getJavaType() == JavaType.MESSAGE) {
        throw new UnsupportedOperationException(
          "FieldDescriptor.getDefaultValue() called on an embedded message " +
          "field.");
      }
      return defaultValue;
    }

    /** Get the {@code FieldOptions}, defined in {@code descriptor.proto}. */
    public FieldOptions getOptions() { return proto.getOptions(); }

    /** Is this field an extension? */
    public boolean isExtension() { return proto.hasExtendee(); }

    /**
     * Get the field's containing type. For extensions, this is the type being
     * extended, not the location where the extension was defined.  See
     * {@link #getExtensionScope()}.
     */
    public Descriptor getContainingType() { return containingType; }

    /**
     * For extensions defined nested within message types, gets the outer
     * type.  Not valid for non-extension fields.  For example, consider
     * this {@code .proto} file:
     * <pre>
     *   message Foo {
     *     extensions 1000 to max;
     *   }
     *   extend Foo {
     *     optional int32 baz = 1234;
     *   }
     *   message Bar {
     *     extend Foo {
     *       optional int32 qux = 4321;
     *     }
     *   }
     * </pre>
     * Both {@code baz}'s and {@code qux}'s containing type is {@code Foo}.
     * However, {@code baz}'s extension scope is {@code null} while
     * {@code qux}'s extension scope is {@code Bar}.
     */
    public Descriptor getExtensionScope() {
      if (!isExtension()) {
        throw new UnsupportedOperationException(
          "This field is not an extension.");
      }
      return extensionScope;
    }

    /** For embedded message and group fields, gets the field's type. */
    public Descriptor getMessageType() {
      if (getJavaType() != JavaType.MESSAGE) {
        throw new UnsupportedOperationException(
          "This field is not of message type.");
      }
      return messageType;
    }

    /** For enum fields, gets the field's type. */
    public EnumDescriptor getEnumType() {
      if (getJavaType() != JavaType.ENUM) {
        throw new UnsupportedOperationException(
          "This field is not of enum type.");
      }
      return enumType;
    }

    /**
     * Compare with another {@code FieldDescriptor}.  This orders fields in
     * "canonical" order, which simply means ascending order by field number.
     * {@code other} must be a field of the same type -- i.e.
     * {@code getContainingType()} must return the same {@code Descriptor} for
     * both fields.
     *
     * @return negative, zero, or positive if {@code this} is less than,
     *         equal to, or greater than {@code other}, respectively.
     */
    public int compareTo(FieldDescriptor other) {
      if (other.containingType != containingType) {
        throw new IllegalArgumentException(
          "FieldDescriptors can only be compared to other FieldDescriptors " +
          "for fields of the same message type.");
      }
      return getNumber() - other.getNumber();
    }

    private final int index;

    private final FieldDescriptorProto proto;
    private final String fullName;
    private final FileDescriptor file;
    private final Descriptor extensionScope;

    // Possibly initialized during cross-linking.
    private Type type;
    private Descriptor containingType;
    private Descriptor messageType;
    private EnumDescriptor enumType;
    private Object defaultValue;

    public static enum Type {
      DOUBLE  (FieldDescriptorProto.Type.TYPE_DOUBLE  , JavaType.DOUBLE     ),
      FLOAT   (FieldDescriptorProto.Type.TYPE_FLOAT   , JavaType.FLOAT      ),
      INT64   (FieldDescriptorProto.Type.TYPE_INT64   , JavaType.LONG       ),
      UINT64  (FieldDescriptorProto.Type.TYPE_UINT64  , JavaType.LONG       ),
      INT32   (FieldDescriptorProto.Type.TYPE_INT32   , JavaType.INT        ),
      FIXED64 (FieldDescriptorProto.Type.TYPE_FIXED64 , JavaType.LONG       ),
      FIXED32 (FieldDescriptorProto.Type.TYPE_FIXED32 , JavaType.INT        ),
      BOOL    (FieldDescriptorProto.Type.TYPE_BOOL    , JavaType.BOOLEAN    ),
      STRING  (FieldDescriptorProto.Type.TYPE_STRING  , JavaType.STRING     ),
      GROUP   (FieldDescriptorProto.Type.TYPE_GROUP   , JavaType.MESSAGE    ),
      MESSAGE (FieldDescriptorProto.Type.TYPE_MESSAGE , JavaType.MESSAGE    ),
      BYTES   (FieldDescriptorProto.Type.TYPE_BYTES   , JavaType.BYTE_STRING),
      UINT32  (FieldDescriptorProto.Type.TYPE_UINT32  , JavaType.INT        ),
      ENUM    (FieldDescriptorProto.Type.TYPE_ENUM    , JavaType.ENUM       ),
      SFIXED32(FieldDescriptorProto.Type.TYPE_SFIXED32, JavaType.INT        ),
      SFIXED64(FieldDescriptorProto.Type.TYPE_SFIXED64, JavaType.LONG       ),
      SINT32  (FieldDescriptorProto.Type.TYPE_SINT32  , JavaType.INT        ),
      SINT64  (FieldDescriptorProto.Type.TYPE_SINT64  , JavaType.LONG       );

      private Type(FieldDescriptorProto.Type proto, JavaType javaType) {
        this.proto = proto;
        this.javaType = javaType;

        if (this.ordinal() != proto.getNumber() - 1) {
          throw new RuntimeException(
            "descriptor.proto changed but Desrciptors.java wasn't updated.");
        }
      }

      private FieldDescriptorProto.Type proto;
      private JavaType javaType;

      public FieldDescriptorProto.Type toProto() { return proto; }
      public JavaType getJavaType() { return javaType; }

      public static Type valueOf(FieldDescriptorProto.Type type) {
        return values()[type.getNumber() - 1];
      }
    }

    static {
      // Refuse to init if someone added a new declared type.
      if (Type.values().length != FieldDescriptorProto.Type.values().length) {
        throw new RuntimeException(
          "descriptor.proto has a new declared type but Desrciptors.java " +
          "wasn't updated.");
      }
    }

    public static enum JavaType {
      INT(0),
      LONG(0L),
      FLOAT(0F),
      DOUBLE(0D),
      BOOLEAN(false),
      STRING(""),
      BYTE_STRING(ByteString.EMPTY),
      ENUM(null),
      MESSAGE(null);

      private JavaType(Object defaultDefault) {
        this.defaultDefault = defaultDefault;
      }

      /**
       * The default default value for fields of this type, if it's a primitive
       * type.  This is meant for use inside this file only, hence is private.
       */
      private Object defaultDefault;
    }

    private FieldDescriptor(FieldDescriptorProto proto,
                            FileDescriptor file,
                            Descriptor parent,
                            int index,
                            boolean isExtension)
                     throws DescriptorValidationException {
      this.index = index;
      this.proto = proto;
      this.fullName = computeFullName(file, parent, proto.getName());
      this.file = file;

      if (proto.hasType()) {
        this.type = Type.valueOf(proto.getType());
      }

      if (getNumber() <= 0) {
        throw new DescriptorValidationException(this,
          "Field numbers must be positive integers.");
      }

      if (isExtension) {
        if (!proto.hasExtendee()) {
          throw new DescriptorValidationException(this,
            "FieldDescriptorProto.extendee not set for extension field.");
        }
        this.containingType = null;  // Will be filled in when cross-linking
        if (parent != null) {
          this.extensionScope = parent;
        } else {
          this.extensionScope = null;
        }
      } else {
        if (proto.hasExtendee()) {
          throw new DescriptorValidationException(this,
            "FieldDescriptorProto.extendee set for non-extension field.");
        }
        this.containingType = parent;
        this.extensionScope = null;
      }

      file.pool.addSymbol(this);
    }

    /** Look up and cross-link all field types, etc. */
    private void crossLink() throws DescriptorValidationException {
      if (proto.hasExtendee()) {
        GenericDescriptor extendee =
          file.pool.lookupSymbol(proto.getExtendee(), this);
        if (!(extendee instanceof Descriptor)) {
          throw new DescriptorValidationException(this,
            "\"" + proto.getExtendee() + "\" is not a message type.");
        }
        this.containingType = (Descriptor)extendee;

        if (!getContainingType().isExtensionNumber(getNumber())) {
          throw new DescriptorValidationException(this,
            "\"" + getContainingType().getFullName() + "\" does not declare " +
            getNumber() + " as an extension number.");
        }
      }

      if (proto.hasTypeName()) {
        GenericDescriptor typeDescriptor =
          file.pool.lookupSymbol(proto.getTypeName(), this);

        if (!proto.hasType()) {
          // Choose field type based on symbol.
          if (typeDescriptor instanceof Descriptor) {
            this.type = Type.MESSAGE;
          } else if (typeDescriptor instanceof EnumDescriptor) {
            this.type = Type.ENUM;
          } else {
            throw new DescriptorValidationException(this,
              "\"" + proto.getTypeName() + "\" is not a type.");
          }
        }

        if (getJavaType() == JavaType.MESSAGE) {
          if (!(typeDescriptor instanceof Descriptor)) {
            throw new DescriptorValidationException(this,
              "\"" + proto.getTypeName() + "\" is not a message type.");
          }
          this.messageType = (Descriptor)typeDescriptor;

          if (proto.hasDefaultValue()) {
            throw new DescriptorValidationException(this,
              "Messages can't have default values.");
          }
        } else if (getJavaType() == JavaType.ENUM) {
          if (!(typeDescriptor instanceof EnumDescriptor)) {
            throw new DescriptorValidationException(this,
              "\"" + proto.getTypeName() + "\" is not an enum type.");
          }
          this.enumType = (EnumDescriptor)typeDescriptor;
        } else {
          throw new DescriptorValidationException(this,
            "Field with primitive type has type_name.");
        }
      } else {
        if (getJavaType() == JavaType.MESSAGE ||
            getJavaType() == JavaType.ENUM) {
          throw new DescriptorValidationException(this,
            "Field with message or enum type missing type_name.");
        }
      }

      // We don't attempt to parse the default value until here because for
      // enums we need the enum type's descriptor.
      if (proto.hasDefaultValue()) {
        if (isRepeated()) {
          throw new DescriptorValidationException(this,
            "Repeated fields cannot have default values.");
        }

        try {
          switch (getType()) {
            case INT32:
            case SINT32:
            case SFIXED32:
              defaultValue = TextFormat.parseInt32(proto.getDefaultValue());
              break;
            case UINT32:
            case FIXED32: {
              defaultValue = TextFormat.parseUInt32(proto.getDefaultValue());
              break;
            }
            case INT64:
            case SINT64:
            case SFIXED64:
              defaultValue = TextFormat.parseInt64(proto.getDefaultValue());
              break;
            case UINT64:
            case FIXED64: {
              defaultValue = TextFormat.parseUInt64(proto.getDefaultValue());
              break;
            }
            case FLOAT:
              defaultValue = Float.valueOf(proto.getDefaultValue());
              break;
            case DOUBLE:
              defaultValue = Double.valueOf(proto.getDefaultValue());
              break;
            case BOOL:
              defaultValue = Boolean.valueOf(proto.getDefaultValue());
              break;
            case STRING:
              defaultValue = proto.getDefaultValue();
              break;
            case BYTES:
              try {
                defaultValue =
                  TextFormat.unescapeBytes(proto.getDefaultValue());
              } catch (TextFormat.InvalidEscapeSequence e) {
                throw new DescriptorValidationException(this,
                  "Couldn't parse default value: " + e.getMessage());
              }
              break;
            case ENUM:
              defaultValue = enumType.findValueByName(proto.getDefaultValue());
              if (defaultValue == null) {
                throw new DescriptorValidationException(this,
                  "Unknown enum default value: \"" +
                  proto.getDefaultValue() + "\"");
              }
              break;
            case MESSAGE:
            case GROUP:
              throw new DescriptorValidationException(this,
                "Message type had default value.");
          }
        } catch (NumberFormatException e) {
          DescriptorValidationException validationException =
            new DescriptorValidationException(this,
              "Could not parse default value: \"" +
              proto.getDefaultValue() + "\"");
          validationException.initCause(e);
          throw validationException;
        }
      } else {
        // Determine the default default for this field.
        if (isRepeated()) {
          defaultValue = Collections.EMPTY_LIST;
        } else {
          switch (getJavaType()) {
            case ENUM:
              // We guarantee elsewhere that an enum type always has at least
              // one possible value.
              defaultValue = enumType.getValues().get(0);
              break;
            case MESSAGE:
              defaultValue = null;
              break;
            default:
              defaultValue = getJavaType().defaultDefault;
              break;
          }
        }
      }

      if (!isExtension()) {
        file.pool.addFieldByNumber(this);
      }

      if (containingType != null &&
          containingType.getOptions().getMessageSetWireFormat()) {
        if (isExtension()) {
          if (!isOptional() || getType() != Type.MESSAGE) {
            throw new DescriptorValidationException(this,
              "Extensions of MessageSets must be optional messages.");
          }
        } else {
          throw new DescriptorValidationException(this,
            "MessageSets cannot have fields, only extensions.");
        }
      }
    }
  }

  // =================================================================

  /** Describes an enum type. */
  public static final class EnumDescriptor implements GenericDescriptor {
    /**
     * Get the index of this descriptor within its parent.
     * @see Descriptors.Descriptor#getIndex()
     */
    public int getIndex() { return index; }

    /** Convert the descriptor to its protocol message representation. */
    public EnumDescriptorProto toProto() { return proto; }

    /** Get the type's unqualified name. */
    public String getName() { return proto.getName(); }

    /**
     * Get the type's fully-qualified name.
     * @see Descriptors.Descriptor#getFullName()
     */
    public String getFullName() { return fullName; }

    /** Get the {@link FileDescriptor} containing this descriptor. */
    public FileDescriptor getFile() { return file; }

    /** If this is a nested type, get the outer descriptor, otherwise null. */
    public Descriptor getContainingType() { return containingType; }

    /** Get the {@code EnumOptions}, defined in {@code descriptor.proto}. */
    public EnumOptions getOptions() { return proto.getOptions(); }

    /** Get a list of defined values for this enum. */
    public List<EnumValueDescriptor> getValues() {
      return Collections.unmodifiableList(Arrays.asList(values));
    }

    /**
     * Find an enum value by name.
     * @param name The unqualified name of the value (e.g. "FOO").
     * @return the value's decsriptor, or {@code null} if not found.
     */
    public EnumValueDescriptor findValueByName(String name) {
      GenericDescriptor result = file.pool.findSymbol(fullName + "." + name);
      if (result != null && result instanceof EnumValueDescriptor) {
        return (EnumValueDescriptor)result;
      } else {
        return null;
      }
    }

    /**
     * Find an enum value by number.  If multiple enum values have the same
     * number, this returns the first defined value with that number.
     * @param number The value's number.
     * @return the value's decsriptor, or {@code null} if not found.
     */
    public EnumValueDescriptor findValueByNumber(int number) {
      return file.pool.enumValuesByNumber.get(
        new DescriptorPool.DescriptorIntPair(this, number));
    }

    private final int index;
    private final EnumDescriptorProto proto;
    private final String fullName;
    private final FileDescriptor file;
    private final Descriptor containingType;
    private EnumValueDescriptor[] values;

    private EnumDescriptor(EnumDescriptorProto proto,
                           FileDescriptor file,
                           Descriptor parent,
                           int index)
                    throws DescriptorValidationException {
      this.index = index;
      this.proto = proto;
      this.fullName = computeFullName(file, parent, proto.getName());
      this.file = file;
      this.containingType = parent;

      if (proto.getValueCount() == 0) {
        // We cannot allow enums with no values because this would mean there
        // would be no valid default value for fields of this type.
        throw new DescriptorValidationException(this,
          "Enums must contain at least one value.");
      }

      values = new EnumValueDescriptor[proto.getValueCount()];
      for (int i = 0; i < proto.getValueCount(); i++) {
        this.values[i] = new EnumValueDescriptor(
          proto.getValue(i), file, this, i);
      }

      file.pool.addSymbol(this);
    }
  }

  // =================================================================

  /**
   * Describes one value within an enum type.  Note that multiple defined
   * values may have the same number.  In generated Java code, all values
   * with the same number after the first become aliases of the first.
   * However, they still have independent EnumValueDescriptors.
   */
  public static final class EnumValueDescriptor implements GenericDescriptor {
    /**
     * Get the index of this descriptor within its parent.
     * @see Descriptors.Descriptor#getIndex()
     */
    public int getIndex() { return index; }

    /** Convert the descriptor to its protocol message representation. */
    public EnumValueDescriptorProto toProto() { return proto; }

    /** Get the value's unqualified name. */
    public String getName() { return proto.getName(); }

    /** Get the value's number. */
    public int getNumber() { return proto.getNumber(); }

    /**
     * Get the value's fully-qualified name.
     * @see Descriptors.Descriptor#getFullName()
     */
    public String getFullName() { return fullName; }

    /** Get the {@link FileDescriptor} containing this descriptor. */
    public FileDescriptor getFile() { return file; }

    /** Get the value's enum type. */
    public EnumDescriptor getType() { return type; }

    /**
     * Get the {@code EnumValueOptions}, defined in {@code descriptor.proto}.
     */
    public EnumValueOptions getOptions() { return proto.getOptions(); }

    private final int index;
    private final EnumValueDescriptorProto proto;
    private final String fullName;
    private final FileDescriptor file;
    private final EnumDescriptor type;

    private EnumValueDescriptor(EnumValueDescriptorProto proto,
                                FileDescriptor file,
                                EnumDescriptor parent,
                                int index)
                         throws DescriptorValidationException {
      this.index = index;
      this.proto = proto;
      this.file = file;
      this.type = parent;

      this.fullName = parent.getFullName() + "." + proto.getName();

      file.pool.addSymbol(this);
      file.pool.addEnumValueByNumber(this);
    }
  }

  // =================================================================

  /** Describes a service type. */
  public static final class ServiceDescriptor implements GenericDescriptor {
    /**
     * Get the index of this descriptor within its parent.
     * * @see Descriptors.Descriptor#getIndex()
     */
    public int getIndex() { return index; }

    /** Convert the descriptor to its protocol message representation. */
    public ServiceDescriptorProto toProto() { return proto; }

    /** Get the type's unqualified name. */
    public String getName() { return proto.getName(); }

    /**
     * Get the type's fully-qualified name.
     * @see Descriptors.Descriptor#getFullName()
     */
    public String getFullName() { return fullName; }

    /** Get the {@link FileDescriptor} containing this descriptor. */
    public FileDescriptor getFile() { return file; }

    /** Get the {@code ServiceOptions}, defined in {@code descriptor.proto}. */
    public ServiceOptions getOptions() { return proto.getOptions(); }

    /** Get a list of methods for this service. */
    public List<MethodDescriptor> getMethods() {
      return Collections.unmodifiableList(Arrays.asList(methods));
    }

    /**
     * Find a method by name.
     * @param name The unqualified name of the method (e.g. "Foo").
     * @return the method's decsriptor, or {@code null} if not found.
     */
    public MethodDescriptor findMethodByName(String name) {
      GenericDescriptor result = file.pool.findSymbol(fullName + "." + name);
      if (result != null && result instanceof MethodDescriptor) {
        return (MethodDescriptor)result;
      } else {
        return null;
      }
    }

    private final int index;
    private final ServiceDescriptorProto proto;
    private final String fullName;
    private final FileDescriptor file;
    private MethodDescriptor[] methods;

    private ServiceDescriptor(ServiceDescriptorProto proto,
                              FileDescriptor file,
                              int index)
                       throws DescriptorValidationException {
      this.index = index;
      this.proto = proto;
      this.fullName = computeFullName(file, null, proto.getName());
      this.file = file;

      this.methods = new MethodDescriptor[proto.getMethodCount()];
      for (int i = 0; i < proto.getMethodCount(); i++) {
        this.methods[i] = new MethodDescriptor(
          proto.getMethod(i), file, this, i);
      }

      file.pool.addSymbol(this);
    }

    private void crossLink() throws DescriptorValidationException {
      for (int i = 0; i < methods.length; i++) {
        methods[i].crossLink();
      }
    }
  }

  // =================================================================

  /**
   * Describes one method within a service type.
   */
  public static final class MethodDescriptor implements GenericDescriptor {
    /**
     * Get the index of this descriptor within its parent.
     * * @see Descriptors.Descriptor#getIndex()
     */
    public int getIndex() { return index; }

    /** Convert the descriptor to its protocol message representation. */
    public MethodDescriptorProto toProto() { return proto; }

    /** Get the method's unqualified name. */
    public String getName() { return proto.getName(); }

    /**
     * Get the method's fully-qualified name.
     * @see Descriptors.Descriptor#getFullName()
     */
    public String getFullName() { return fullName; }

    /** Get the {@link FileDescriptor} containing this descriptor. */
    public FileDescriptor getFile() { return file; }

    /** Get the method's service type. */
    public ServiceDescriptor getService() { return service; }

    /** Get the method's input type. */
    public Descriptor getInputType() { return inputType; }

    /** Get the method's output type. */
    public Descriptor getOutputType() { return outputType; }

    /**
     * Get the {@code MethodOptions}, defined in {@code descriptor.proto}.
     */
    public MethodOptions getOptions() { return proto.getOptions(); }

    private final int index;
    private final MethodDescriptorProto proto;
    private final String fullName;
    private final FileDescriptor file;
    private final ServiceDescriptor service;

    // Initialized during cross-linking.
    private Descriptor inputType;
    private Descriptor outputType;

    private MethodDescriptor(MethodDescriptorProto proto,
                             FileDescriptor file,
                             ServiceDescriptor parent,
                             int index)
                      throws DescriptorValidationException {
      this.index = index;
      this.proto = proto;
      this.file = file;
      this.service = parent;

      this.fullName = parent.getFullName() + "." + proto.getName();

      file.pool.addSymbol(this);
    }

    private void crossLink() throws DescriptorValidationException {
      GenericDescriptor inputType =
        file.pool.lookupSymbol(proto.getInputType(), this);
      if (!(inputType instanceof Descriptor)) {
        throw new DescriptorValidationException(this,
          "\"" + proto.getInputType() + "\" is not a message type.");
      }
      this.inputType = (Descriptor)inputType;

      GenericDescriptor outputType =
        file.pool.lookupSymbol(proto.getOutputType(), this);
      if (!(outputType instanceof Descriptor)) {
        throw new DescriptorValidationException(this,
          "\"" + proto.getOutputType() + "\" is not a message type.");
      }
      this.outputType = (Descriptor)outputType;
    }
  }

  // =================================================================

  private static String computeFullName(FileDescriptor file,
                                        Descriptor parent,
                                        String name) {
    if (parent != null) {
      return parent.getFullName() + "." + name;
    } else if (file.getPackage().length() > 0) {
      return file.getPackage() + "." + name;
    } else {
      return name;
    }
  }

  // =================================================================

  /**
   * All descriptors except {@code FileDescriptor} implement this to make
   * {@code DescriptorPool}'s life easier.
   */
  private static interface GenericDescriptor {
    Message toProto();
    String getName();
    String getFullName();
    FileDescriptor getFile();
  }

  /**
   * Thrown when building descriptors fails because the source DescriptorProtos
   * are not valid.
   */
  public static class DescriptorValidationException extends Exception {
    /** Gets the full name of the descriptor where the error occurred. */
    public String getProblemSymbolName() { return name; }

    /**
     * Gets the the protocol message representation of the invalid descriptor.
     */
    public Message getProblemProto() { return proto; }

    /**
     * Gets a human-readable description of the error.
     */
    public String getDescription() { return description; }

    private final String name;
    private final Message proto;
    private final String description;

    private DescriptorValidationException(GenericDescriptor problemDescriptor,
                                          String description) {
      super(problemDescriptor.getFullName() + ": " + description);

      // Note that problemDescriptor may be partially uninitialized, so we
      // don't want to expose it directly to the user.  So, we only provide
      // the name and the original proto.
      this.name = problemDescriptor.getFullName();
      this.proto = problemDescriptor.toProto();
      this.description = description;
    }

    private DescriptorValidationException(FileDescriptor problemDescriptor,
                                          String description) {
      super(problemDescriptor.getName() + ": " + description);

      // Note that problemDescriptor may be partially uninitialized, so we
      // don't want to expose it directly to the user.  So, we only provide
      // the name and the original proto.
      this.name = problemDescriptor.getName();
      this.proto = problemDescriptor.toProto();
      this.description = description;
    }
  }

  // =================================================================

  /**
   * A private helper class which contains lookup tables containing all the
   * descriptors defined in a particular file.
   */
  private static final class DescriptorPool {
    DescriptorPool(FileDescriptor[] dependencies) {
      this.dependencies = new DescriptorPool[dependencies.length];

      for (int i = 0; i < dependencies.length; i++)  {
        this.dependencies[i] = dependencies[i].pool;
      }

      for (int i = 0; i < dependencies.length; i++)  {
        try {
          addPackage(dependencies[i].getPackage(), dependencies[i]);
        } catch (DescriptorValidationException e) {
          // Can't happen, because addPackage() only fails when the name
          // conflicts with a non-package, but we have not yet added any
          // non-packages at this point.
          assert false;
        }
      }
    }

    final DescriptorPool[] dependencies;

    final Map<String, GenericDescriptor> descriptorsByName =
      new HashMap<String, GenericDescriptor>();
    final Map<DescriptorIntPair, FieldDescriptor> fieldsByNumber =
      new HashMap<DescriptorIntPair, FieldDescriptor>();
    final Map<DescriptorIntPair, EnumValueDescriptor> enumValuesByNumber =
      new HashMap<DescriptorIntPair, EnumValueDescriptor>();

    /** Find a generic descriptor by fully-qualified name. */
    GenericDescriptor findSymbol(String fullName) {
      GenericDescriptor result = descriptorsByName.get(fullName);
      if (result != null) return result;

      for (int i = 0; i < dependencies.length; i++) {
        result = dependencies[i].descriptorsByName.get(fullName);
        if (result != null) return result;
      }

      return null;
    }

    /**
     * Look up a descriptor by name, relative to some other descriptor.
     * The name may be fully-qualified (with a leading '.'),
     * partially-qualified, or unqualified.  C++-like name lookup semantics
     * are used to search for the matching descriptor.
     */
    GenericDescriptor lookupSymbol(String name,
                                   GenericDescriptor relativeTo)
                            throws DescriptorValidationException {
      // TODO(kenton):  This could be optimized in a number of ways.

      GenericDescriptor result;
      if (name.startsWith(".")) {
        // Fully-qualified name.
        result = findSymbol(name.substring(1));
      } else {
        // If "name" is a compound identifier, we want to search for the
        // first component of it, then search within it for the rest.
        int firstPartLength = name.indexOf('.');
        String firstPart;
        if (firstPartLength == -1) {
          firstPart = name;
        } else {
          firstPart = name.substring(0, firstPartLength);
        }

        // We will search each parent scope of "relativeTo" looking for the
        // symbol.
        StringBuilder scopeToTry = new StringBuilder(relativeTo.getFullName());

        while (true) {
          // Chop off the last component of the scope.
          int dotpos = scopeToTry.lastIndexOf(".");
          if (dotpos == -1) {
            result = findSymbol(name);
            break;
          } else {
            scopeToTry.setLength(dotpos + 1);

            // Append firstPart and try to find.
            scopeToTry.append(firstPart);
            result = findSymbol(scopeToTry.toString());

            if (result != null) {
              if (firstPartLength != -1) {
                // We only found the first part of the symbol.  Now look for
                // the whole thing.  If this fails, we *don't* want to keep
                // searching parent scopes.
                scopeToTry.setLength(dotpos + 1);
                scopeToTry.append(name);
                result = findSymbol(scopeToTry.toString());
              }
              break;
            }

            // Not found.  Remove the name so we can try again.
            scopeToTry.setLength(dotpos);
          }
        }
      }

      if (result == null) {
        throw new DescriptorValidationException(relativeTo,
          "\"" + name + "\" is not defined.");
      } else {
        return result;
      }
    }

    /**
     * Adds a symbol to the symbol table.  If a symbol with the same name
     * already exists, throws an error.
     */
    void addSymbol(GenericDescriptor descriptor)
            throws DescriptorValidationException {
      validateSymbolName(descriptor);

      String fullName = descriptor.getFullName();
      int dotpos = fullName.lastIndexOf('.');

      GenericDescriptor old = descriptorsByName.put(fullName, descriptor);
      if (old != null) {
        descriptorsByName.put(fullName, old);

        if (descriptor.getFile() == old.getFile()) {
          if (dotpos == -1) {
            throw new DescriptorValidationException(descriptor,
              "\"" + fullName + "\" is already defined.");
          } else {
            throw new DescriptorValidationException(descriptor,
              "\"" + fullName.substring(dotpos + 1) +
              "\" is already defined in \"" +
              fullName.substring(0, dotpos) + "\".");
          }
        } else {
          throw new DescriptorValidationException(descriptor,
            "\"" + fullName + "\" is already defined in file \"" +
            old.getFile().getName() + "\".");
        }
      }
    }

    /**
     * Represents a package in the symbol table.  We use PackageDescriptors
     * just as placeholders so that someone cannot define, say, a message type
     * that has the same name as an existing package.
     */
    static final class PackageDescriptor implements GenericDescriptor {
      public Message toProto()        { return file.toProto(); }
      public String getName()         { return name;           }
      public String getFullName()     { return fullName;       }
      public FileDescriptor getFile() { return file;           }

      PackageDescriptor(String name, String fullName, FileDescriptor file) {
        this.file = file;
        this.fullName = fullName;
        this.name = name;
      }

      String name;
      String fullName;
      FileDescriptor file;
    }

    /**
     * Adds a package to the symbol tables.  If a package by the same name
     * already exists, that is fine, but if some other kind of symbol exists
     * under the same name, an exception is thrown.  If the package has
     * multiple components, this also adds the parent package(s).
     */
    void addPackage(String fullName, FileDescriptor file)
             throws DescriptorValidationException {
      int dotpos = fullName.lastIndexOf('.');
      String name;
      if (dotpos != -1) {
        addPackage(fullName.substring(0, dotpos), file);
        name = fullName.substring(dotpos + 1);
      } else {
        name = fullName;
      }

      GenericDescriptor old =
        descriptorsByName.put(fullName,
          new PackageDescriptor(fullName, name, file));
      if (old != null) {
        descriptorsByName.put(fullName, old);
        if (!(old instanceof PackageDescriptor)) {
          throw new DescriptorValidationException(file,
            "\"" + name + "\" is already defined (as something other than a " +
            "package) in file \"" + old.getFile().getName() + "\".");
        }
      }
    }

    /** A (GenericDescriptor, int) pair, used as a map key. */
    static final class DescriptorIntPair {
      final GenericDescriptor descriptor;
      final int number;

      DescriptorIntPair(GenericDescriptor descriptor, int number) {
        this.descriptor = descriptor;
        this.number = number;
      }

      public int hashCode() {
        return descriptor.hashCode() * ((1 << 16) - 1) + number;
      }
      public boolean equals(Object obj) {
        if (!(obj instanceof DescriptorIntPair)) return false;
        DescriptorIntPair other = (DescriptorIntPair)obj;
        return descriptor == other.descriptor && number == other.number;
      }
    }

    /**
     * Adds a field to the fieldsByNumber table.  Throws an exception if a
     * field with hte same containing type and number already exists.
     */
    void addFieldByNumber(FieldDescriptor field)
                   throws DescriptorValidationException {
      DescriptorIntPair key =
        new DescriptorIntPair(field.getContainingType(), field.getNumber());
      FieldDescriptor old = fieldsByNumber.put(key, field);
      if (old != null) {
        fieldsByNumber.put(key, old);
        throw new DescriptorValidationException(field,
          "Field number " + field.getNumber() +
          "has already been used in \"" +
          field.getContainingType().getFullName() +
          "\" by field \"" + old.getName() + "\".");
      }
    }

    /**
     * Adds an enum value to the enumValuesByNumber table.  If an enum value
     * with the same type and number already exists, does nothing.  (This is
     * allowed; the first value define with the number takes precedence.)
     */
    void addEnumValueByNumber(EnumValueDescriptor value) {
      DescriptorIntPair key =
        new DescriptorIntPair(value.getType(), value.getNumber());
      EnumValueDescriptor old = enumValuesByNumber.put(key, value);
      if (old != null) {
        enumValuesByNumber.put(key, old);
        // Not an error:  Multiple enum values may have the same number, but
        // we only want the first one in the map.
      }
    }

    /**
     * Verifies that the descriptor's name is valid (i.e. it contains only
     * letters, digits, and underscores, and does not start with a digit).
     */
    void validateSymbolName(GenericDescriptor descriptor)
                     throws DescriptorValidationException {
      String name = descriptor.getName();
      if (name.length() == 0) {
        throw new DescriptorValidationException(descriptor, "Missing name.");
      } else {
        boolean valid = true;
        for (int i = 0; i < name.length(); i++) {
          char c = name.charAt(i);
          // Non-ASCII characters are not valid in protobuf identifiers, even
          // if they are letters or digits.
          if (c >= 128) {
            valid = false;
          }
          // First character must be letter or _.  Subsequent characters may
          // be letters, numbers, or digits.
          if (Character.isLetter(c) || c == '_' ||
              (Character.isDigit(c) && i > 0)) {
            // Valid
          } else {
            valid = false;
          }
        }
        if (!valid) {
          throw new DescriptorValidationException(descriptor,
            "\"" + name + "\" is not a valid identifier.");
        }
      }
    }
  }
}
