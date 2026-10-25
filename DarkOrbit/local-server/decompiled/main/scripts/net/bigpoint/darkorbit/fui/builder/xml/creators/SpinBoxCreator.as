package net.bigpoint.darkorbit.fui.builder.xml.creators
{
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.components.spinbar.AbstractSpinBox;
   import net.bigpoint.darkorbit.fui.components.spinbar.HorizontalSpinBox;
   import net.bigpoint.darkorbit.mvc.common.utils.ParserUtility;
   
   public class SpinBoxCreator extends AbstractCreator implements IXMLNodeCreator
   {
      
      public static const ATTRIBUTENAME_SPINBOX_TYPE:String = "type";
      
      public static const ATTRIBUTENAME_SPINBOX_TYPE_HORIZONTALVALUE:String = "horizontal";
      
      public static const ATTRIBUTENAME_SPINBOX_TYPE_VERTICALVALUE:String = "vertical";
      
      public function SpinBoxCreator()
      {
         super();
      }
      
      override protected function initializeAttributeMapping() : void
      {
         super.initializeAttributeMapping();
         this.attributeToMethodMap["inputEnabled"] = this.handleInputEnabled;
      }
      
      protected function handleInputEnabled(param1:AbstractSpinBox, param2:String) : void
      {
         param1.inputEnabled = ParserUtility.parseBooleanFromXmlAtribute(param2,true);
      }
      
      public function create(param1:XML) : ICoreponent
      {
         var _loc2_:AbstractSpinBox = null;
         var _loc3_:String = param1.attribute(ATTRIBUTENAME_SPINBOX_TYPE);
         if(_loc3_ == null)
         {
            _loc3_ = ATTRIBUTENAME_SPINBOX_TYPE_HORIZONTALVALUE;
         }
         switch(_loc3_)
         {
            case ATTRIBUTENAME_SPINBOX_TYPE_HORIZONTALVALUE:
               _loc2_ = this.createHorizontalSpinBox(param1);
               break;
            case ATTRIBUTENAME_SPINBOX_TYPE_VERTICALVALUE:
               _loc2_ = this.createVerticalSpinBox(param1);
         }
         mapXMLNodeAttributes(_loc2_,param1);
         return _loc2_;
      }
      
      protected function createHorizontalSpinBox(param1:XML) : AbstractSpinBox
      {
         return new HorizontalSpinBox();
      }
      
      protected function createVerticalSpinBox(param1:XML) : AbstractSpinBox
      {
         return null;
      }
   }
}

