package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.BaseStackCommand;
   
   public class HangarShipFavouriteCommand implements IModule
   {
      
      private static var _instance:HangarShipFavouriteCommand;
      
      public var resultId:int = 0;
      
      public var errorMessage:BaseStackCommand;
      
      public function HangarShipFavouriteCommand(param1:int = 0, param2:BaseStackCommand = null)
      {
         super();
         this.resultId = param1;
         if(param2 == null)
         {
            this.errorMessage = new BaseStackCommand();
         }
         else
         {
            this.errorMessage = param2;
         }
      }
      
      public static function get instance() : HangarShipFavouriteCommand
      {
         return _instance || (_instance = new HangarShipFavouriteCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 18874;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.resultId = param1.readByte();
         this.resultId = 0xFF & ((0xFF & this.resultId) >>> 7 % 8 | (0xFF & this.resultId) << 8 - 7 % 8);
         this.resultId = this.resultId > 127 ? int(this.resultId - 256) : this.resultId;
         this.errorMessage = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMessage)
         {
            this.errorMessage.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(18874);
         param1.writeByte(0xFF & ((0xFF & this.resultId) << 7 % 8 | (0xFF & this.resultId) >>> 8 - 7 % 8));
         if(null != this.errorMessage)
         {
            this.errorMessage.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

