package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AttributeSpaceUpdateCommand implements IModule
   {
      
      private static var _instance:AttributeSpaceUpdateCommand;
      
      public static const SPACETYPE_CARGO:int = 0;
      
      public static const SPACETYPE_BATTERIES:int = 1;
      
      public static const SPACETYPE_ROCKETS:int = 2;
      
      public static const SPACETYPE__MAX:int = 3;
      
      public var spaceType:int = 0;
      
      public var spaceLeft:int = 0;
      
      public function AttributeSpaceUpdateCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.spaceType = param1;
         this.spaceLeft = param2;
      }
      
      public static function get instance() : AttributeSpaceUpdateCommand
      {
         return _instance || (_instance = new AttributeSpaceUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 97;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.spaceType = param1.readShort();
         this.spaceLeft = param1.readInt();
         this.spaceLeft = this.spaceLeft << 12 % 32 | this.spaceLeft >>> 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(97);
         param1.writeShort(this.spaceType);
         param1.writeInt(this.spaceLeft >>> 12 % 32 | this.spaceLeft << 32 - 12 % 32);
      }
   }
}

