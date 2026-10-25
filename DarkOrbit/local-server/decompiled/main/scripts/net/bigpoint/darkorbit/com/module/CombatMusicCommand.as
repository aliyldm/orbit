package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CombatMusicCommand implements IModule
   {
      
      private static var _instance:CombatMusicCommand;
      
      public static const COMBATEVENT_COMBAT_START:int = 0;
      
      public static const COMBATEVENT_COMBAT_END:int = 1;
      
      public static const COMBATEVENT__MAX:int = 2;
      
      public var combatEvent:int = 0;
      
      public function CombatMusicCommand(param1:int = 0)
      {
         super();
         this.combatEvent = param1;
      }
      
      public static function get instance() : CombatMusicCommand
      {
         return _instance || (_instance = new CombatMusicCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -12650;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.combatEvent = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-12650);
         param1.writeShort(this.combatEvent);
      }
   }
}

