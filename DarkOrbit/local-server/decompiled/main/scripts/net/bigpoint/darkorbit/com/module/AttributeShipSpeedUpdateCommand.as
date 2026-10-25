package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AttributeShipSpeedUpdateCommand implements IModule
   {
      
      private static var _instance:AttributeShipSpeedUpdateCommand;
      
      public var newSpeed:int = 0;
      
      public var displaySpeed:int = 0;
      
      public function AttributeShipSpeedUpdateCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.newSpeed = param1;
         this.displaySpeed = param2;
      }
      
      public static function get instance() : AttributeShipSpeedUpdateCommand
      {
         return _instance || (_instance = new AttributeShipSpeedUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 96;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.newSpeed = param1.readInt();
         this.newSpeed = this.newSpeed << 12 % 32 | this.newSpeed >>> 32 - 12 % 32;
         this.displaySpeed = param1.readInt();
         this.displaySpeed = this.displaySpeed << 1 % 32 | this.displaySpeed >>> 32 - 1 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(96);
         param1.writeInt(this.newSpeed >>> 12 % 32 | this.newSpeed << 32 - 12 % 32);
         param1.writeInt(this.displaySpeed >>> 1 % 32 | this.displaySpeed << 32 - 1 % 32);
      }
   }
}

