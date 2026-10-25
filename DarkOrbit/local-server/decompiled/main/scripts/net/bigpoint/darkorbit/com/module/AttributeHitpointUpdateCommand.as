package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AttributeHitpointUpdateCommand implements IModule
   {
      
      private static var _instance:AttributeHitpointUpdateCommand;
      
      public var hitpointsNow:int = 0;
      
      public var hitpointsMax:int = 0;
      
      public function AttributeHitpointUpdateCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.hitpointsNow = param1;
         this.hitpointsMax = param2;
      }
      
      public static function get instance() : AttributeHitpointUpdateCommand
      {
         return _instance || (_instance = new AttributeHitpointUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 8;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.hitpointsNow = param1.readInt();
         this.hitpointsNow = this.hitpointsNow << 7 % 32 | this.hitpointsNow >>> 32 - 7 % 32;
         this.hitpointsMax = param1.readInt();
         this.hitpointsMax = this.hitpointsMax << 10 % 32 | this.hitpointsMax >>> 32 - 10 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(8);
         param1.writeInt(this.hitpointsNow >>> 7 % 32 | this.hitpointsNow << 32 - 7 % 32);
         param1.writeInt(this.hitpointsMax >>> 10 % 32 | this.hitpointsMax << 32 - 10 % 32);
      }
   }
}

