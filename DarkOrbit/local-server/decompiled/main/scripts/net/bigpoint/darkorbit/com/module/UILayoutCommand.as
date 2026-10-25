package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UILayoutCommand implements IModule
   {
      
      private static var _instance:UILayoutCommand;
      
      public var featureBars:Vector.<UIFeatureBarCommand>;
      
      public function UILayoutCommand(param1:Vector.<UIFeatureBarCommand> = null)
      {
         super();
         if(param1 == null)
         {
            this.featureBars = new Vector.<UIFeatureBarCommand>();
         }
         else
         {
            this.featureBars = param1;
         }
      }
      
      public static function get instance() : UILayoutCommand
      {
         return _instance || (_instance = new UILayoutCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -29223;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:UIFeatureBarCommand = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.featureBars.length > 0)
         {
            this.featureBars.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = UIFeatureBarCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.featureBars.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:UIFeatureBarCommand = null;
         param1.writeShort(-29223);
         param1.writeByte(this.featureBars.length);
         for each(_loc2_ in this.featureBars)
         {
            _loc2_.write(param1);
         }
      }
   }
}

