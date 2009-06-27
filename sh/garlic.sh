# garlic shell helpers

# cd into the work path of a garlic target
gcd ()
{
  cd `garlic path $1`
}

# cd into probable plugin dir of a garlic target
gcdp ()
{
  here=`pwd | sed 's/.*\///'`
  cd `garlic path $1`/vendor/plugins/$here
}

# cd back up to enclosing garlic project
gup ()
{
  cd `pwd | sed 's/\.garlic.*//'`
}

# push changes back to local garlic origin, resetting the origin
gpush ()
{
  if [ `pwd | sed 's/\.garlic//'` == `pwd` ]; then
      echo "gpush can only be used in a garlic work repo";
  else
    git push origin $1 2>&1 | grep -v warning;
    here=`pwd`;
    gup;
    git reset --hard;
    cd $here;
  fi
}
