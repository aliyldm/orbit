package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class WarGameTeamCountUpdateCommand implements IModule
   {
      
      private static var _instance:WarGameTeamCountUpdateCommand;
      
      public var teamRedMemersCount:int = 0;
      
      public var teamBlueMemersCount:int = 0;
      
      public function WarGameTeamCountUpdateCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.teamRedMemersCount = param2;
         this.teamBlueMemersCount = param1;
      }
      
      public static function get instance() : WarGameTeamCountUpdateCommand
      {
         return _instance || (_instance = new WarGameTeamCountUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 14497;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.teamRedMemersCount = param1.readInt();
         this.teamRedMemersCount = this.teamRedMemersCount << 3 % 32 | this.teamRedMemersCount >>> 32 - 3 % 32;
         this.teamBlueMemersCount = param1.readInt();
         this.teamBlueMemersCount = this.teamBlueMemersCount >>> 7 % 32 | this.teamBlueMemersCount << 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(14497);
         param1.writeInt(this.teamRedMemersCount >>> 3 % 32 | this.teamRedMemersCount << 32 - 3 % 32);
         param1.writeInt(this.teamBlueMemersCount << 7 % 32 | this.teamBlueMemersCount >>> 32 - 7 % 32);
      }
   }
}

