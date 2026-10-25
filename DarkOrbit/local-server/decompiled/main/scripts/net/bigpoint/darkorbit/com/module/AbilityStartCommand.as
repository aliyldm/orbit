package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AbilityStartCommand implements IModule
   {
      
      private static var _instance:AbilityStartCommand;
      
      public var selectedAbilityId:int = 0;
      
      public var activatorId:int = 0;
      
      public var noStopCommand:Boolean = false;
      
      public function AbilityStartCommand(param1:int = 0, param2:int = 0, param3:Boolean = false)
      {
         super();
         this.selectedAbilityId = param1;
         this.activatorId = param2;
         this.noStopCommand = param3;
      }
      
      public static function get instance() : AbilityStartCommand
      {
         return _instance || (_instance = new AbilityStartCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 279;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 9;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.selectedAbilityId = param1.readInt();
         this.selectedAbilityId = this.selectedAbilityId >>> 12 % 32 | this.selectedAbilityId << 32 - 12 % 32;
         this.activatorId = param1.readInt();
         this.activatorId = this.activatorId << 4 % 32 | this.activatorId >>> 32 - 4 % 32;
         this.noStopCommand = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(279);
         param1.writeInt(this.selectedAbilityId << 12 % 32 | this.selectedAbilityId >>> 32 - 12 % 32);
         param1.writeInt(this.activatorId >>> 4 % 32 | this.activatorId << 32 - 4 % 32);
         param1.writeBoolean(this.noStopCommand);
      }
   }
}

