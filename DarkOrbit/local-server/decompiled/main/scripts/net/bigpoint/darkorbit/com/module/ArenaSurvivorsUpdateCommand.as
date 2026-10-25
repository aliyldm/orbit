package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ArenaSurvivorsUpdateCommand implements IModule
   {
      
      private static var _instance:ArenaSurvivorsUpdateCommand;
      
      public var participants:int = 0;
      
      public var arenaId:int = 0;
      
      public var survivors:int = 0;
      
      public function ArenaSurvivorsUpdateCommand(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.participants = param3;
         this.arenaId = param1;
         this.survivors = param2;
      }
      
      public static function get instance() : ArenaSurvivorsUpdateCommand
      {
         return _instance || (_instance = new ArenaSurvivorsUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 18936;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.participants = param1.readInt();
         this.participants = this.participants >>> 5 % 32 | this.participants << 32 - 5 % 32;
         this.arenaId = param1.readInt();
         this.arenaId = this.arenaId << 11 % 32 | this.arenaId >>> 32 - 11 % 32;
         this.survivors = param1.readInt();
         this.survivors = this.survivors << 1 % 32 | this.survivors >>> 32 - 1 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(18936);
         param1.writeInt(this.participants << 5 % 32 | this.participants >>> 32 - 5 % 32);
         param1.writeInt(this.arenaId >>> 11 % 32 | this.arenaId << 32 - 11 % 32);
         param1.writeInt(this.survivors >>> 1 % 32 | this.survivors << 32 - 1 % 32);
      }
   }
}

