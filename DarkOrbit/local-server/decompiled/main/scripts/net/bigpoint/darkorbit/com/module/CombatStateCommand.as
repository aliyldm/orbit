package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CombatStateCommand implements IModule
   {
      
      private static var _instance:CombatStateCommand;
      
      public static const COMBATSTATETYPE_TARGET_OUT_OF_RANGE:int = 0;
      
      public static const COMBATSTATETYPE_TARGET_BACK_IN_RANGE:int = 1;
      
      public static const COMBATSTATETYPE_ESCAPED:int = 2;
      
      public static const COMBATSTATETYPE_FIGHT_IN_DMZ:int = 3;
      
      public static const COMBATSTATETYPE_ATTACK_STOPPED:int = 4;
      
      public static const COMBATSTATETYPE_TARGET_REGISTERED_FOR_TG:int = 5;
      
      public static const COMBATSTATETYPE_YOU_REGISTERED_FOR_TG:int = 6;
      
      public static const COMBATSTATETYPE_YOU_REGISTERED_FOR_TG_NO_TARGET:int = 7;
      
      public static const COMBATSTATETYPE__MAX:int = 8;
      
      public var combatState:int = 0;
      
      public function CombatStateCommand(param1:int = 0)
      {
         super();
         this.combatState = param1;
      }
      
      public static function get instance() : CombatStateCommand
      {
         return _instance || (_instance = new CombatStateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 11;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.combatState = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(11);
         param1.writeShort(this.combatState);
      }
   }
}

