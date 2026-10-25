package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SectorControlSectorStateCommand implements IModule
   {
      
      private static var _instance:SectorControlSectorStateCommand;
      
      public static const ACTIONTYPE_NONE:int = 0;
      
      public static const ACTIONTYPE_CAPTURING:int = 1;
      
      public static const ACTIONTYPE_NEUTRALIZING:int = 2;
      
      public static const ACTIONTYPE__MAX:int = 3;
      
      public var sectorId:String = "";
      
      public var actionType:int = 0;
      
      public var progressOwner:FactionModule;
      
      public var invaders:Vector.<FactionModule>;
      
      public var captureProgress:int = 0;
      
      public var timeTillUnlock:Number = 0;
      
      public function SectorControlSectorStateCommand(param1:String = "", param2:FactionModule = null, param3:Vector.<FactionModule> = null, param4:int = 0, param5:Number = 0, param6:int = 0)
      {
         super();
         this.sectorId = param1;
         this.actionType = param6;
         if(param2 == null)
         {
            this.progressOwner = new FactionModule();
         }
         else
         {
            this.progressOwner = param2;
         }
         if(param3 == null)
         {
            this.invaders = new Vector.<FactionModule>();
         }
         else
         {
            this.invaders = param3;
         }
         this.captureProgress = param4;
         this.timeTillUnlock = param5;
      }
      
      public static function get instance() : SectorControlSectorStateCommand
      {
         return _instance || (_instance = new SectorControlSectorStateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -27294;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 18;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:FactionModule = null;
         this.sectorId = param1.readUTF();
         this.actionType = param1.readShort();
         this.progressOwner = FactionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.progressOwner)
         {
            this.progressOwner.read(param1);
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.invaders.length > 0)
         {
            this.invaders.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = FactionModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.invaders.push(_loc4_);
            _loc2_++;
         }
         this.captureProgress = param1.readInt();
         this.captureProgress = this.captureProgress >>> 13 % 32 | this.captureProgress << 32 - 13 % 32;
         this.timeTillUnlock = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:FactionModule = null;
         param1.writeShort(-27294);
         param1.writeUTF(this.sectorId);
         param1.writeShort(this.actionType);
         if(null != this.progressOwner)
         {
            this.progressOwner.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.invaders.length);
         for each(_loc2_ in this.invaders)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.captureProgress << 13 % 32 | this.captureProgress >>> 32 - 13 % 32);
         param1.writeDouble(this.timeTillUnlock);
      }
   }
}

