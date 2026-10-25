package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UILayerAdvertisementCommand implements IModule
   {
      
      private static var _instance:UILayerAdvertisementCommand;
      
      public var alignment:AlignmentModule;
      
      public var closeable:Boolean = false;
      
      public var moveable:Boolean = false;
      
      public var advertisementKey:String = "";
      
      public function UILayerAdvertisementCommand(param1:AlignmentModule = null, param2:Boolean = false, param3:Boolean = false, param4:String = "")
      {
         super();
         if(param1 == null)
         {
            this.alignment = new AlignmentModule();
         }
         else
         {
            this.alignment = param1;
         }
         this.closeable = param2;
         this.moveable = param3;
         this.advertisementKey = param4;
      }
      
      public static function get instance() : UILayerAdvertisementCommand
      {
         return _instance || (_instance = new UILayerAdvertisementCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 127;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.alignment = AlignmentModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.alignment)
         {
            this.alignment.read(param1);
         }
         this.closeable = param1.readBoolean();
         this.moveable = param1.readBoolean();
         this.advertisementKey = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(127);
         if(null != this.alignment)
         {
            this.alignment.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeBoolean(this.closeable);
         param1.writeBoolean(this.moveable);
         param1.writeUTF(this.advertisementKey);
      }
   }
}

