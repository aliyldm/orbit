package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RogueLiteModifierModule implements IModule
   {
      
      private static var _instance:RogueLiteModifierModule;
      
      public var modifierId:int = 0;
      
      public function RogueLiteModifierModule(param1:int = 0)
      {
         super();
         this.modifierId = param1;
      }
      
      public static function get instance() : RogueLiteModifierModule
      {
         return _instance || (_instance = new RogueLiteModifierModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -8500;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.modifierId = param1.readInt();
         this.modifierId = this.modifierId >>> 13 % 32 | this.modifierId << 32 - 13 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-8500);
         param1.writeInt(this.modifierId << 13 % 32 | this.modifierId >>> 32 - 13 % 32);
      }
   }
}

