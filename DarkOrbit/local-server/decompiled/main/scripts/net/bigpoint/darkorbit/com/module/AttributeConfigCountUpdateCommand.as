package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AttributeConfigCountUpdateCommand implements IModule
   {
      
      private static var _instance:AttributeConfigCountUpdateCommand;
      
      public var configCount:int = 0;
      
      public function AttributeConfigCountUpdateCommand(param1:int = 0)
      {
         super();
         this.configCount = param1;
      }
      
      public static function get instance() : AttributeConfigCountUpdateCommand
      {
         return _instance || (_instance = new AttributeConfigCountUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 98;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.configCount = param1.readInt();
         this.configCount = this.configCount << 6 % 32 | this.configCount >>> 32 - 6 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(98);
         param1.writeInt(this.configCount >>> 6 % 32 | this.configCount << 32 - 6 % 32);
      }
   }
}

