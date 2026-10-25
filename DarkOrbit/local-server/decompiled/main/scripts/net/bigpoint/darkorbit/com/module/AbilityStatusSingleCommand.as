package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AbilityStatusSingleCommand implements IModule
   {
      
      private static var _instance:AbilityStatusSingleCommand;
      
      public var abilityTypeId:int = 0;
      
      public var isActivatable:Boolean = false;
      
      public function AbilityStatusSingleCommand(param1:int = 0, param2:Boolean = false)
      {
         super();
         this.abilityTypeId = param1;
         this.isActivatable = param2;
      }
      
      public static function get instance() : AbilityStatusSingleCommand
      {
         return _instance || (_instance = new AbilityStatusSingleCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 276;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.abilityTypeId = param1.readInt();
         this.abilityTypeId = this.abilityTypeId << 6 % 32 | this.abilityTypeId >>> 32 - 6 % 32;
         this.isActivatable = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(276);
         param1.writeInt(this.abilityTypeId >>> 6 % 32 | this.abilityTypeId << 32 - 6 % 32);
         param1.writeBoolean(this.isActivatable);
      }
   }
}

