package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetHitpointsUpdateCommand implements IModule
   {
      
      private static var _instance:PetHitpointsUpdateCommand;
      
      public var hitpointsNow:int = 0;
      
      public var hitpointsMax:int = 0;
      
      public var useRepairGear:Boolean = false;
      
      public function PetHitpointsUpdateCommand(param1:int = 0, param2:int = 0, param3:Boolean = false)
      {
         super();
         this.hitpointsNow = param1;
         this.hitpointsMax = param2;
         this.useRepairGear = param3;
      }
      
      public static function get instance() : PetHitpointsUpdateCommand
      {
         return _instance || (_instance = new PetHitpointsUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 158;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 9;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.hitpointsNow = param1.readInt();
         this.hitpointsNow = this.hitpointsNow << 13 % 32 | this.hitpointsNow >>> 32 - 13 % 32;
         this.hitpointsMax = param1.readInt();
         this.hitpointsMax = this.hitpointsMax << 8 % 32 | this.hitpointsMax >>> 32 - 8 % 32;
         this.useRepairGear = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(158);
         param1.writeInt(this.hitpointsNow >>> 13 % 32 | this.hitpointsNow << 32 - 13 % 32);
         param1.writeInt(this.hitpointsMax >>> 8 % 32 | this.hitpointsMax << 32 - 8 % 32);
         param1.writeBoolean(this.useRepairGear);
      }
   }
}

