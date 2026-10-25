package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CreateMinimapMark implements IModule
   {
      
      private static var _instance:CreateMinimapMark;
      
      public static const MINIMAPMARKTYPE_PING:int = 0;
      
      public static const MINIMAPMARKTYPE__MAX:int = 1;
      
      public var count:int = 0;
      
      public var scale:Number = 0;
      
      public var uid:String = "";
      
      public var positionX:int = 0;
      
      public var interval:Number = 0;
      
      public var positionY:int = 0;
      
      public var inverse:Boolean = false;
      
      public var soundModule:SoundTriggerModule;
      
      public var type:int = 0;
      
      public function CreateMinimapMark(param1:String = "", param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:Number = 0, param7:Number = 0, param8:Boolean = false, param9:SoundTriggerModule = null)
      {
         super();
         this.count = param5;
         this.scale = param7;
         this.uid = param1;
         this.positionX = param2;
         this.interval = param6;
         this.positionY = param3;
         this.inverse = param8;
         if(param9 == null)
         {
            this.soundModule = new SoundTriggerModule();
         }
         else
         {
            this.soundModule = param9;
         }
         this.type = param4;
      }
      
      public static function get instance() : CreateMinimapMark
      {
         return _instance || (_instance = new CreateMinimapMark());
      }
      
      public function getLibcomModuleId() : int
      {
         return -24639;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 23;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.count = param1.readInt();
         this.count = this.count >>> 6 % 32 | this.count << 32 - 6 % 32;
         this.scale = param1.readFloat();
         this.uid = param1.readUTF();
         this.positionX = param1.readInt();
         this.positionX = this.positionX >>> 7 % 32 | this.positionX << 32 - 7 % 32;
         this.interval = param1.readFloat();
         this.positionY = param1.readInt();
         this.positionY = this.positionY >>> 16 % 32 | this.positionY << 32 - 16 % 32;
         this.inverse = param1.readBoolean();
         this.soundModule = SoundTriggerModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.soundModule)
         {
            this.soundModule.read(param1);
         }
         this.type = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-24639);
         param1.writeInt(this.count << 6 % 32 | this.count >>> 32 - 6 % 32);
         param1.writeFloat(this.scale);
         param1.writeUTF(this.uid);
         param1.writeInt(this.positionX << 7 % 32 | this.positionX >>> 32 - 7 % 32);
         param1.writeFloat(this.interval);
         param1.writeInt(this.positionY << 16 % 32 | this.positionY >>> 32 - 16 % 32);
         param1.writeBoolean(this.inverse);
         if(null != this.soundModule)
         {
            this.soundModule.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeShort(this.type);
      }
   }
}

