package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DestructionTypeModule implements IModule
   {
      
      private static var _instance:DestructionTypeModule;
      
      public static const DESTRUCTIONCAUSE_PLAYER:int = 0;
      
      public static const DESTRUCTIONCAUSE_NPC:int = 1;
      
      public static const DESTRUCTIONCAUSE_RADITATION:int = 2;
      
      public static const DESTRUCTIONCAUSE_MINE:int = 3;
      
      public static const DESTRUCTIONCAUSE_MISC:int = 4;
      
      public static const DESTRUCTIONCAUSE_BATTLESTATION:int = 5;
      
      public static const DESTRUCTIONCAUSE__MAX:int = 6;
      
      public var cause:int = 0;
      
      public function DestructionTypeModule(param1:int = 0)
      {
         super();
         this.cause = param1;
      }
      
      public static function get instance() : DestructionTypeModule
      {
         return _instance || (_instance = new DestructionTypeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 259;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.cause = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(259);
         param1.writeShort(this.cause);
      }
   }
}

