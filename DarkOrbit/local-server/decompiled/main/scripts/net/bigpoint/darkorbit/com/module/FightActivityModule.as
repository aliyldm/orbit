package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class FightActivityModule extends PlayerAttributeModule
   {
      
      private static var _instance:FightActivityModule;
      
      public var active:Boolean = false;
      
      public function FightActivityModule(param1:Boolean = false)
      {
         super();
         this.active = param1;
      }
      
      public static function get instance() : FightActivityModule
      {
         return _instance || (_instance = new FightActivityModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 26678;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.active = param1.readBoolean();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(26678);
         super.write(param1);
         param1.writeBoolean(this.active);
      }
   }
}

