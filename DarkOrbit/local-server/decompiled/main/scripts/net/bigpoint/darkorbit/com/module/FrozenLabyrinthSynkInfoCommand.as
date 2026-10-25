package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class FrozenLabyrinthSynkInfoCommand implements IModule
   {
      
      private static var _instance:FrozenLabyrinthSynkInfoCommand;
      
      public var zone:int = 0;
      
      public var mapName:String = "";
      
      public var isGateActive:Boolean = false;
      
      public var respawnInSeconds:Number = 0;
      
      public function FrozenLabyrinthSynkInfoCommand(param1:String = "", param2:int = 0, param3:Number = 0, param4:Boolean = false)
      {
         super();
         this.zone = param2;
         this.mapName = param1;
         this.isGateActive = param4;
         this.respawnInSeconds = param3;
      }
      
      public static function get instance() : FrozenLabyrinthSynkInfoCommand
      {
         return _instance || (_instance = new FrozenLabyrinthSynkInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -16228;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 15;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.zone = param1.readInt();
         this.zone = this.zone << 9 % 32 | this.zone >>> 32 - 9 % 32;
         this.mapName = param1.readUTF();
         this.isGateActive = param1.readBoolean();
         this.respawnInSeconds = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-16228);
         param1.writeInt(this.zone >>> 9 % 32 | this.zone << 32 - 9 % 32);
         param1.writeUTF(this.mapName);
         param1.writeBoolean(this.isGateActive);
         param1.writeDouble(this.respawnInSeconds);
      }
   }
}

