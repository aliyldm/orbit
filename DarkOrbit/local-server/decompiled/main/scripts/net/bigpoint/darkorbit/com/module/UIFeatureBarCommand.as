package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UIFeatureBarCommand implements IModule
   {
      
      private static var _instance:UIFeatureBarCommand;
      
      public static const FEATUREBARTYPE_NOT_ASSIGNED:int = 0;
      
      public static const FEATUREBARTYPE_GAME_FEATURE_BAR:int = 1;
      
      public static const FEATUREBARTYPE_GENERIC_FEATURE_BAR:int = 2;
      
      public static const FEATUREBARTYPE_GAME_NEW_FEATURE_BAR:int = 3;
      
      public static const FEATUREBARTYPE__MAX:int = 4;
      
      public var featureBarItems:Vector.<ItemCommand>;
      
      public var featureBarOrder:String = "";
      
      public var featureBarPosition:String = "";
      
      public var featureBarType:int = 0;
      
      public function UIFeatureBarCommand(param1:int = 0, param2:Vector.<ItemCommand> = null, param3:String = "", param4:String = "")
      {
         super();
         if(param2 == null)
         {
            this.featureBarItems = new Vector.<ItemCommand>();
         }
         else
         {
            this.featureBarItems = param2;
         }
         this.featureBarOrder = param4;
         this.featureBarPosition = param3;
         this.featureBarType = param1;
      }
      
      public static function get instance() : UIFeatureBarCommand
      {
         return _instance || (_instance = new UIFeatureBarCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -14909;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:ItemCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.featureBarItems.length > 0)
         {
            this.featureBarItems.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ItemCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.featureBarItems.push(_loc4_);
            _loc2_++;
         }
         this.featureBarOrder = param1.readUTF();
         this.featureBarPosition = param1.readUTF();
         this.featureBarType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:ItemCommand = null;
         param1.writeShort(-14909);
         param1.writeByte(this.featureBarItems.length);
         for each(_loc2_ in this.featureBarItems)
         {
            _loc2_.write(param1);
         }
         param1.writeUTF(this.featureBarOrder);
         param1.writeUTF(this.featureBarPosition);
         param1.writeShort(this.featureBarType);
      }
   }
}

