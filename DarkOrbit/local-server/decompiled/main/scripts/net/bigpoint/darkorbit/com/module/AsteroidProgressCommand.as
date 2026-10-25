package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AsteroidProgressCommand implements IModule
   {
      
      private static var _instance:AsteroidProgressCommand;
      
      public var battleStationId:int = 0;
      
      public var ownProgress:Number = 0;
      
      public var bestProgress:Number = 0;
      
      public var ownClanName:String = "";
      
      public var bestProgressClanName:String = "";
      
      public var state:EquippedModulesModule;
      
      public var buildButtonActive:Boolean = false;
      
      public function AsteroidProgressCommand(param1:int = 0, param2:Number = 0, param3:Number = 0, param4:String = "", param5:String = "", param6:EquippedModulesModule = null, param7:Boolean = false)
      {
         super();
         this.battleStationId = param1;
         this.ownProgress = param2;
         this.bestProgress = param3;
         this.ownClanName = param4;
         this.bestProgressClanName = param5;
         if(param6 == null)
         {
            this.state = new EquippedModulesModule();
         }
         else
         {
            this.state = param6;
         }
         this.buildButtonActive = param7;
      }
      
      public static function get instance() : AsteroidProgressCommand
      {
         return _instance || (_instance = new AsteroidProgressCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6002;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 17;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.battleStationId = param1.readInt();
         this.battleStationId = this.battleStationId << 6 % 32 | this.battleStationId >>> 32 - 6 % 32;
         this.ownProgress = param1.readFloat();
         this.bestProgress = param1.readFloat();
         this.ownClanName = param1.readUTF();
         this.bestProgressClanName = param1.readUTF();
         this.state = EquippedModulesModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.state)
         {
            this.state.read(param1);
         }
         this.buildButtonActive = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(6002);
         param1.writeInt(this.battleStationId >>> 6 % 32 | this.battleStationId << 32 - 6 % 32);
         param1.writeFloat(this.ownProgress);
         param1.writeFloat(this.bestProgress);
         param1.writeUTF(this.ownClanName);
         param1.writeUTF(this.bestProgressClanName);
         if(null != this.state)
         {
            this.state.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeBoolean(this.buildButtonActive);
      }
   }
}

